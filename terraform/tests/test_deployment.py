import logging
import subprocess
import time
from itertools import batched

import jubilant
import lightkube
import pytest
import requests
import tenacity
from constants import AUTH_HOSTNAME, M2M_HOSTNAME, UI_HOSTNAME
from lightkube.core.exceptions import ApiError
from lightkube.resources.core_v1 import ConfigMap, Service


logging.getLogger("jubilant.wait").setLevel("WARNING")

logger = logging.getLogger(__name__)

# Kept in one place so the workaround below can be reverted or retargeted easily.
OAUTH2_PROXY_APP = "oauth2-proxy"

# The cross-model oauth offer (in the iam model) that oauth2-proxy integrates
# with; toggled by the hydra-operator#591 workaround.
OAUTH_OFFER = "oauth-offer:oauth"


@pytest.fixture()
def lightkube_client() -> lightkube.Client:
    client = lightkube.Client(field_manager="kubeflow")
    return client


class TestCharm:
    @pytest.mark.dependency()
    def test_apply_terraform_solution(
        self,
        juju: jubilant.Juju,
        tf_vars,
        solution_module_path,
        request,
    ):
        """Initialize and apply the selected Terraform solution root module."""
        subprocess.run(
            ["terraform", "init"],
            check=True,
            cwd=solution_module_path,
        )
        apply_cmd = [
            "terraform",
            "apply",
            "-auto-approve",
            "-var",
            f"model_uuid={juju.show_model().model_uuid}",
        ]
        # The iam solution spans multiple models with cross-model offers; apply
        # serially to work around juju/terraform-provider-juju#1308.
        if request.config.getoption("--auth-type") == "iam":
            apply_cmd.append("-parallelism=1")
        subprocess.run(
            apply_cmd + tf_vars,
            check=True,
            cwd=solution_module_path,
        )

    @pytest.mark.dependency(depends=["TestCharm::test_apply_terraform_solution"])
    def test_assert_deployment(
        self, juju: jubilant.Juju, lightkube_client, request
    ):
        """
        Wait for the applications to become active and idle and verify its public URL access.
        """
        auth_type = request.config.getoption("--auth-type")

        # The ambient-iam solution spans multiple models; wait for the provider
        # models to settle before asserting on the kubeflow model.
        if auth_type == "iam":
            # iam-core (traefik / postgresql / self-signed) does not depend on
            # the external DNS, so wait for it first: this guarantees traefik's
            # LoadBalancer IP exists before we resolve the hostnames below.
            _wait_model_active("iam-core")

            # The IAM charms and cross-model callbacks only reconcile to active
            # once the external hostnames resolve to their LoadBalancer IPs.
            configure_dns(lightkube_client)

            for model_name in ("istio-system", "iam"):
                _wait_model_active(model_name)

        apps = list(juju.status().apps.keys())

        # BEGIN workaround: oauth2-proxy-k8s#278 (remove once fixed upstream).
        # To revert, drop this branch and always run the plain juju.wait below.
        if auth_type == "iam":
            _wait_kubeflow_active(juju, apps)
        else:
            for batched_apps in batched(apps, 5):
                juju.wait(
                    lambda status, apps=batched_apps: jubilant.all_active(
                        status, *apps
                    ),
                    timeout=3600,
                )
        # END workaround: oauth2-proxy-k8s#278

        if auth_type == "iam":
            # Hydra does not patch an already-registered client's redirect_uri
            # when it changes (http:// -> https://), which breaks the OIDC flow;
            # re-register the client before probing the UI (hydra-operator#591).
            # Remove when https://github.com/canonical/hydra-operator/issues/591 is resolved.
            _refresh_hydra_oauth_client(juju, apps)

            # UI traffic is served over TLS by the dedicated UI ambient gateway.
            # The hostname resolves via the DNS configured above; the gateway
            # certificate is self-signed, so TLS verification is disabled.
            result_status, result_text = fetch_response(
                f"https://{UI_HOSTNAME}", verify=False
            )
            assert result_status == 200
            assert '"page":"/login"' in result_text
            return

        # Verify deployment by checking the public URL
        istio_service = "istio-ingressgateway-workload"
        if request.config.getoption("--service-mesh-type") == "ambient":
            istio_service = "istio-ingress-k8s-istio"
        url = get_public_url(lightkube_client, "kubeflow", istio_service)
        result_status, result_text = fetch_response(url)
        assert result_status == 200
        assert "Log in to Your Account" in result_text
        assert "Email Address" in result_text
        assert "Password" in result_text


@tenacity.retry(
    wait=tenacity.wait_exponential(multiplier=2, min=1, max=10),
    stop=tenacity.stop_after_attempt(30),
    reraise=True,
)
def get_public_url(
    lightkube_client: lightkube.Client, bundle_name: str, service_name: str
):
    """Extracts public URL from service istio-ingress-k8s-istio."""
    istio_ingress_k8s_svc = lightkube_client.get(
        Service, service_name, namespace=bundle_name
    )
    address = (
        istio_ingress_k8s_svc.status.loadBalancer.ingress[0].hostname
        or istio_ingress_k8s_svc.status.loadBalancer.ingress[0].ip
    )
    public_url = f"http://{address}"
    return public_url


@tenacity.retry(
    wait=tenacity.wait_exponential(multiplier=2, min=1, max=10),
    stop=tenacity.stop_after_attempt(30),
    reraise=True,
)
def fetch_response(url, headers=None, verify=True):
    """Fetch provided URL and return (status, text)."""
    response = requests.get(url, headers=headers, verify=verify)
    return response.status_code, response.text


# BEGIN workaround: oauth2-proxy-k8s#278 (remove this whole helper once fixed).
# https://github.com/canonical/oauth2-proxy-k8s-operator/issues/278
def _wait_kubeflow_active(juju: jubilant.Juju, apps: list[str]) -> None:
    """Wait for the kubeflow model to go active (oauth2-proxy-k8s#278 workaround).

    oauth2-proxy-k8s can settle (agent idle) into a non-active state (e.g.
    maintenance "Status check: DOWN" or blocked) and never recover on its own;
    restarting the pod moves it to active. Wait until oauth2-proxy is idle, roll
    it out if it did not settle active, then wait for the whole model to settle.
    """

    def _oauth2_proxy_idle(status: jubilant.Status) -> bool:
        app = status.apps.get(OAUTH2_PROXY_APP)
        if app is None or not app.units:
            return False
        return all(
            unit.juju_status.current == "idle" for unit in app.units.values()
        )

    juju.wait(_oauth2_proxy_idle, timeout=1800)

    if not jubilant.all_active(juju.status(), OAUTH2_PROXY_APP):
        logger.info(
            "%s settled idle but not active; restarting its statefulset "
            "(oauth2-proxy-k8s#278)",
            OAUTH2_PROXY_APP,
        )
        subprocess.run(
            [
                "kubectl",
                "-n",
                "kubeflow",
                "rollout",
                "restart",
                f"statefulset/{OAUTH2_PROXY_APP}",
            ],
            check=False,
        )

    for batched_apps in batched(apps, 5):
        juju.wait(
            lambda status, apps=batched_apps: jubilant.all_active(status, *apps),
            timeout=1800,
        )
# END workaround: oauth2-proxy-k8s#278


# BEGIN workaround: hydra-operator#591 (remove this whole helper once fixed).
# https://github.com/canonical/hydra-operator/issues/591
def _refresh_hydra_oauth_client(juju: jubilant.Juju, apps: list[str]) -> None:
    """Re-register oauth2-proxy's Hydra client if its redirect_uri is stale.

    Hydra does not patch an already-registered OAuth client when the requirer's
    redirect_uri changes (http:// -> https://), so the OIDC login flow fails
    with a redirect_uri mismatch. Detect the stale http:// entry and toggle the
    oauth relation, which forces Hydra to drop and recreate the client with the
    correct https redirect_uri.
    """
    result = subprocess.run(
        ["juju", "run", "-m", "iam", "hydra/0", "list-oauth-clients"],
        capture_output=True,
        text=True,
        check=True,
    )
    if f"http://{UI_HOSTNAME}" not in result.stdout:
        return

    logger.info(
        "Hydra has a stale http:// redirect_uri for %s; toggling the oauth "
        "relation to force re-registration (hydra-operator#591)",
        UI_HOSTNAME,
    )
    oauth2_proxy_oauth = f"{OAUTH2_PROXY_APP}:oauth"
    # Remove then re-add the relation so Hydra drops and recreates the client.
    subprocess.run(
        ["juju", "remove-relation", "-m", "kubeflow", OAUTH_OFFER, oauth2_proxy_oauth],
        check=True,
    )
    # remove-relation returns before the relation is fully gone; juju rejects a
    # re-integrate while it is still "dying", so retry until removal completes.
    _integrate_oauth_relation(oauth2_proxy_oauth)
    _wait_model_active("iam")
    for batched_apps in batched(apps, 5):
        juju.wait(
            lambda status, apps=batched_apps: jubilant.all_active(status, *apps),
            timeout=1800,
        )


@tenacity.retry(
    retry=tenacity.retry_if_exception_type(subprocess.CalledProcessError),
    wait=tenacity.wait_fixed(10),
    stop=tenacity.stop_after_delay(300),
    reraise=True,
)
def _integrate_oauth_relation(oauth2_proxy_oauth: str) -> None:
    """Re-integrate the oauth relation, retrying while the old one is removing."""
    subprocess.run(
        ["juju", "integrate", "-m", "kubeflow", OAUTH_OFFER, oauth2_proxy_oauth],
        check=True,
    )
# END workaround: hydra-operator#591


def _wait_model_active(model_name: str) -> None:
    """Wait for every application in the given model to be active."""
    model_juju = jubilant.Juju(model=model_name)
    model_apps = list(model_juju.status().apps.keys())
    for batched_apps in batched(model_apps, 5):
        model_juju.wait(
            lambda status, apps=batched_apps: jubilant.all_active(status, *apps),
            timeout=3600,
        )


def _wait_for_lb_ip(
    lightkube_client: lightkube.Client,
    namespace: str,
    labels: dict[str, str],
    timeout: int = 900,
) -> str:
    """Poll until a LoadBalancer Service matching labels has an ingress address."""
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            services = [
                svc
                for svc in lightkube_client.list(
                    Service, namespace=namespace, labels=labels
                )
                if svc.spec and svc.spec.type == "LoadBalancer"
            ]
        except ApiError:
            services = []

        for svc in services:
            lb = svc.status.loadBalancer if svc.status else None
            ingress = lb.ingress if lb else None
            if ingress:
                address = ingress[0].ip or ingress[0].hostname
                if address:
                    return address
        time.sleep(5)

    raise TimeoutError(
        f"No LoadBalancer IP assigned for a service matching {labels} in "
        f"namespace {namespace!r} within {timeout}s"
    )


def _coredns_configmap(lightkube_client: lightkube.Client) -> ConfigMap:
    """Find the CoreDNS ConfigMap (the one holding the Corefile).

    Distro-agnostic: Canonical K8s names it ck-dns-coredns and MicroK8s names it
    coredns, but both keep the config under a Corefile data key.
    """
    for configmap in lightkube_client.list(ConfigMap, namespace="kube-system"):
        if configmap.data and "Corefile" in configmap.data:
            return configmap
    raise RuntimeError("CoreDNS ConfigMap not found in kube-system")


def configure_dns(lightkube_client: lightkube.Client) -> dict[str, str]:
    """Resolve the ambient-iam hostnames to their LoadBalancer IPs.

    Both the in-cluster DNS (CoreDNS) and the runner host (/etc/hosts) are
    updated so the IAM charms and cross-model callbacks can resolve the
    external hostnames and reconcile to active.
    """
    host_to_ip = {
        UI_HOSTNAME: _wait_for_lb_ip(
            lightkube_client,
            "kubeflow",
            {"gateway.networking.k8s.io/gateway-name": "istio-ingress-k8s-ui"},
        ),
        M2M_HOSTNAME: _wait_for_lb_ip(
            lightkube_client,
            "kubeflow",
            {"gateway.networking.k8s.io/gateway-name": "istio-ingress-k8s-m2m"},
        ),
        AUTH_HOSTNAME: _wait_for_lb_ip(
            lightkube_client,
            "iam-core",
            {"kubernetes-resource-handler-scope": "traefik-loadbalancer"},
        ),
    }

    # Inject a hosts block into the existing Corefile (right after the server
    # block opening brace), preserving the cluster's default DNS config.
    hosts_block = (
        "    hosts {\n"
        + "".join(f"        {ip} {host}\n" for host, ip in host_to_ip.items())
        + "        fallthrough\n"
        "    }\n"
    )
    configmap = _coredns_configmap(lightkube_client)
    corefile = configmap.data["Corefile"]
    insert_at = corefile.find("{\n") + len("{\n")
    patched_corefile = corefile[:insert_at] + hosts_block + corefile[insert_at:]

    lightkube_client.patch(
        ConfigMap,
        configmap.metadata.name,
        namespace="kube-system",
        obj={"data": {"Corefile": patched_corefile}},
    )
    # CoreDNS does not always pick up the patched Corefile promptly, so force a
    # rollout to apply the new host entries immediately.
    subprocess.run(
        [
            "kubectl",
            "-n",
            "kube-system",
            "rollout",
            "restart",
            "deployment/coredns",
        ],
        check=True,
    )

    host_entries = "".join(f"{ip} {host}\n" for host, ip in host_to_ip.items())
    subprocess.run(
        ["sudo", "tee", "-a", "/etc/hosts"],
        input=host_entries.encode(),
        check=True,
        stdout=subprocess.DEVNULL,
    )
    return host_to_ip

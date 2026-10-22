import logging
import socket
import subprocess
import time
from itertools import batched

import jubilant
import lightkube
import pytest
import requests
import tenacity
from lightkube.core.exceptions import ApiError
from lightkube.resources.core_v1 import ConfigMap, Service


logging.getLogger("jubilant.wait").setLevel("WARNING")

logger = logging.getLogger(__name__)

# Kept in one place so the workaround below can be reverted or retargeted easily.
OAUTH2_PROXY_APP = "oauth2-proxy"

# The cross-model oauth offer (in the iam model) that oauth2-proxy integrates
# with; toggled by the hydra-operator#591 workaround.
OAUTH_OFFER = "oauth-offer:oauth"

# Custom kfp-api oci-image resource to deploy instead of the charm's default.
KFP_API_IMAGE = "dariofaccin/api-server:2.16.1-65e8152-20261022135745"


@pytest.fixture()
def lightkube_client(model_name: str) -> lightkube.Client:
    client = lightkube.Client(field_manager=model_name)
    return client


class TestCharm:
    @pytest.mark.dependency()
    def test_apply_terraform_solution(
        self,
        juju: jubilant.Juju,
        tf_vars,
        solution_module_path,
        request,
        is_mlflow_standalone,
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
        else:
            apply_cmd.append("-parallelism=5")
        # Standalone MLflow roots do not deploy KFP, so they lack this variable.
        if not is_mlflow_standalone:
            apply_cmd += ["-var", f"kfp_api_image={KFP_API_IMAGE}"]
        subprocess.run(
            apply_cmd + tf_vars,
            check=True,
            cwd=solution_module_path,
        )

    @pytest.mark.dependency(depends=["TestCharm::test_apply_terraform_solution"])
    def test_assert_deployment(
        self,
        juju: jubilant.Juju,
        lightkube_client,
        request,
        hostname_auth,
        hostname_m2m,
        hostname_ui,
        model_name,
        is_mlflow_standalone,
    ):
        """
        Wait for the applications to become active and idle and verify its public URL access.
        """
        auth_type = request.config.getoption("--auth-type")

        # The ambient-iam solution spans multiple models; wait for the provider
        # models to settle before asserting on the application model.
        if auth_type == "iam":
            # iam-core (traefik / postgresql / self-signed) does not depend on
            # the external DNS, so wait for it first: this guarantees traefik's
            # LoadBalancer IP exists before we resolve the hostnames below.
            _wait_model_active("iam-core")

            # The IAM charms and cross-model callbacks only reconcile to active
            # once the external hostnames resolve to their LoadBalancer IPs.
            configure_dns(
                lightkube_client,
                hostname_auth,
                hostname_m2m,
                hostname_ui,
                model_name,
            )

            for system_model_name in ("istio-system", "iam"):
                _wait_model_active(system_model_name)

            # oauth2-proxy's workload recovers once the issuer DNS resolves, but
            # the charm can stay stuck "Failed to replan"; restart it to clear.
            _recover_oauth2_proxy(juju, model_name)

        apps = list(juju.status().apps.keys())

        for batched_apps in batched(apps, 5):
            juju.wait(
                lambda status, apps=batched_apps: jubilant.all_active(
                    status, *apps
                ),
                timeout=3600,
            )

        if auth_type == "iam":
            # Hydra does not patch an already-registered client's redirect_uri
            # when it changes (http:// -> https://), which breaks the OIDC flow;
            # re-register the client before probing the UI (hydra-operator#591).
            # Remove when https://github.com/canonical/hydra-operator/issues/591 is resolved.
            _refresh_hydra_oauth_client(juju, apps, hostname_ui)

            # UI traffic is served over TLS by the dedicated UI ambient gateway.
            # The hostname resolves via the DNS configured above; the gateway
            # certificate is self-signed, so TLS verification is disabled.
            #
            # This is a reachability smoke test only (status 200): it confirms the
            # ingress chain (DNS -> UI gateway -> oauth2-proxy -> IdP login-ui)
            # responds. The login page content itself is verified by the Identity
            # UI UATs ("Run Identity UI UATs" workflow step), which drive a real
            # headless browser and assert the rendered "Sign in" form — a
            # requests.get substring check is brittle because the login-ui is a
            # client-rendered Next.js SPA whose __NEXT_DATA__ shape is not stable.
            #
            # Standalone MLflow has no root-path app on the UI gateway (unlike the
            # Kubeflow dashboard): mlflow-server is served under /mlflow/, so "/"
            # has no HTTPRoute and returns a bare istio-envoy 404. Probe the real
            # UI path so the forward-auth -> IdP login chain is exercised.
            ui_path = "/mlflow/" if is_mlflow_standalone else "/"
            result_status, _ = fetch_response(
                f"https://{hostname_ui}{ui_path}", verify=False
            )
            assert result_status == 200
            return

        # Verify deployment by checking the public URL
        istio_service = "istio-ingressgateway-workload"
        if request.config.getoption("--service-mesh-type") == "ambient":
            istio_service = "istio-ingress-k8s-istio"
        url = get_public_url(lightkube_client, model_name, istio_service)
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


# BEGIN workaround: hydra-operator#591 (remove this whole helper once fixed).
# https://github.com/canonical/hydra-operator/issues/591
def _refresh_hydra_oauth_client(juju: jubilant.Juju, apps: list[str], hostname_ui: str) -> None:
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
    if f"http://{hostname_ui}" not in result.stdout:
        return

    logger.info(
        "Hydra has a stale http:// redirect_uri for %s; toggling the oauth "
        "relation to force re-registration (hydra-operator#591)",
        hostname_ui,
    )
    oauth2_proxy_oauth = f"{OAUTH2_PROXY_APP}:oauth"
    # Remove then re-add the relation so Hydra drops and recreates the client.
    juju.remove_relation(oauth2_proxy_oauth, OAUTH_OFFER)
    # remove-relation returns before the relation is fully gone; juju rejects a
    # re-integrate while it is still "dying", so retry until removal completes.
    _integrate_oauth_relation(juju, oauth2_proxy_oauth)
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
def _integrate_oauth_relation(juju: jubilant.Juju, oauth2_proxy_oauth: str) -> None:
    """Re-integrate the oauth relation, retrying while the old one is removing."""
    juju.integrate(oauth2_proxy_oauth, OAUTH_OFFER)
# END workaround: hydra-operator#591


# BEGIN workaround: oauth2-proxy-k8s "Failed to replan" blocked status.
# After the issuer DNS is configured the workload recovers on its own (the
# pebble check recovers and /ready returns 200), but the charm keeps the
# "Failed to replan the pebble service" BlockedStatus and never clears it on
# update-status (observed on latest/edge rev 29). A fresh pod replans cleanly
# with DNS already in place, so bounce it until the charm reports active.
def _oauth2_proxy_active(juju: jubilant.Juju) -> bool:
    """Whether oauth2-proxy is active (or absent from this model)."""
    status = juju.status()
    return OAUTH2_PROXY_APP not in status.apps or jubilant.all_active(
        status, OAUTH2_PROXY_APP
    )


def _oauth2_proxy_settled(juju: jubilant.Juju, timeout: int = 300) -> None:
    """Poll until oauth2-proxy is active or the timeout elapses."""
    deadline = time.time() + timeout
    while time.time() < deadline:
        if _oauth2_proxy_active(juju):
            return
        time.sleep(10)


def _recover_oauth2_proxy(
    juju: jubilant.Juju, model_name: str, attempts: int = 5
) -> None:
    """Restart oauth2-proxy until the charm reports active."""
    for attempt in range(attempts):
        if _oauth2_proxy_active(juju):
            return
        logger.warning(
            "oauth2-proxy is not active (attempt %d/%d); the workload is "
            "healthy but the charm is stuck 'Failed to replan', so restart it",
            attempt + 1,
            attempts,
        )
        statefulset = f"statefulset/{OAUTH2_PROXY_APP}"
        subprocess.run(
            ["kubectl", "-n", model_name, "rollout", "restart", statefulset],
            check=True,
        )
        subprocess.run(
            [
                "kubectl",
                "-n",
                model_name,
                "rollout",
                "status",
                statefulset,
                "--timeout=300s",
            ],
            check=True,
        )
        _oauth2_proxy_settled(juju)
# END workaround: oauth2-proxy-k8s "Failed to replan" blocked status


def _wait_model_active(model_name: str) -> None:
    """Wait for every application in the given model to be active."""
    model_juju = jubilant.Juju(model=model_name)
    model_apps = list(model_juju.status().apps.keys())
    for batched_apps in batched(model_apps, 5):
        model_juju.wait(
            lambda status, apps=batched_apps: jubilant.all_active(status, *apps),
            timeout=3600,
        )


@tenacity.retry(
    retry=tenacity.retry_if_exception_type(socket.gaierror),
    wait=tenacity.wait_fixed(10),
    stop=tenacity.stop_after_delay(600),
    reraise=True,
)
def _resolve_ipv4(hostname: str) -> list[str]:
    """Resolve a LoadBalancer hostname to its IPv4 addresses.

    A new load balancer's DNS record (e.g. an AWS ELB) can take a few minutes
    to propagate, so retry until it resolves.
    """
    addresses = socket.getaddrinfo(hostname, None, socket.AF_INET, socket.SOCK_STREAM)
    return sorted({address[4][0] for address in addresses})


def _wait_for_lb_ips(
    lightkube_client: lightkube.Client,
    namespace: str,
    labels: dict[str, str],
    timeout: int = 900,
) -> list[str]:
    """Poll until a LoadBalancer Service matching labels has an ingress address.

    Return its IP, or the IPv4 addresses of its hostname on clouds that publish
    one instead (e.g. an AWS ELB on EKS): the CoreDNS hosts plugin and
    /etc/hosts only accept IPs and silently skip any other entry.
    """
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
                if ingress[0].ip:
                    return [ingress[0].ip]
                if ingress[0].hostname:
                    return _resolve_ipv4(ingress[0].hostname)
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


def configure_dns(
    lightkube_client: lightkube.Client,
    hostname_auth: str,
    hostname_m2m: str,
    hostname_ui: str,
    model_name: str,
) -> dict[str, list[str]]:
    """Resolve the ambient-iam hostnames to their LoadBalancer IPs.

    Both the in-cluster DNS (CoreDNS) and the runner host (/etc/hosts) are
    updated so the IAM charms and cross-model callbacks can resolve the
    external hostnames and reconcile to active.
    """
    host_to_ips = {
        hostname_ui: _wait_for_lb_ips(
            lightkube_client,
            model_name,
            {"gateway.networking.k8s.io/gateway-name": "istio-ingress-k8s-ui"},
        ),
        hostname_m2m: _wait_for_lb_ips(
            lightkube_client,
            model_name,
            {"gateway.networking.k8s.io/gateway-name": "istio-ingress-k8s-m2m"},
        ),
        hostname_auth: _wait_for_lb_ips(
            lightkube_client,
            "iam-core",
            {"kubernetes-resource-handler-scope": "traefik-loadbalancer"},
        ),
    }
    logger.info("Mapping the external hostnames to %s", host_to_ips)
    host_entries = [f"{ip} {host}" for host, ips in host_to_ips.items() for ip in ips]

    # Inject a hosts block into the existing Corefile (right after the server
    # block opening brace), preserving the cluster's default DNS config.
    hosts_block = (
        "    hosts {\n"
        + "".join(f"        {entry}\n" for entry in host_entries)
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

    subprocess.run(
        ["sudo", "tee", "-a", "/etc/hosts"],
        input="".join(f"{entry}\n" for entry in host_entries).encode(),
        check=True,
        stdout=subprocess.DEVNULL,
    )
    return host_to_ips

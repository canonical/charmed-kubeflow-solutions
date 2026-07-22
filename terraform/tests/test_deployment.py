import logging
import subprocess

import aiohttp
import jubilant
import lightkube
import pytest
from lightkube.resources.core_v1 import Service


logging.getLogger("jubilant.wait").setLevel("WARNING")


@pytest.fixture()
def lightkube_client() -> lightkube.Client:
    client = lightkube.Client(field_manager="kubeflow")
    return client


class TestCharm:
    @pytest.mark.dependency()
    async def test_apply_terraform_solution(
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
    async def test_assert_deployment(
        self, juju: jubilant.Juju, lightkube_client, request
    ):
        """
        Wait for the applications to become active and idle and verify its public URL access.
        """
        auth_type = request.config.getoption("--auth-type")

        # The ambient-iam solution spans multiple models; wait for the provider
        # models to settle before asserting on the kubeflow model.
        if auth_type == "iam":
            for model_name in ("istio-system", "iam-core", "iam"):
                model_juju = jubilant.Juju(model=model_name)
                model_apps = list(model_juju.status().apps.keys())
                model_juju.wait(
                    lambda status, apps=model_apps: jubilant.all_active(status, *apps),
                    timeout=3600,
                )

        apps = list(juju.status().apps.keys())

        juju.wait(lambda status: jubilant.all_active(status, *apps), timeout=3600)

        if auth_type == "iam":
            # UI traffic is served by the dedicated UI ambient gateway and is
            # matched on the configured external hostname.
            url = get_public_url(
                lightkube_client, "kubeflow", "istio-ingress-k8s-ui-istio"
            )
            result_status, _ = await fetch_response(
                url, headers={"Host": "ui.kubeflow.com"}
            )
            assert result_status == 200
            return

        # Verify deployment by checking the public URL
        istio_service = "istio-ingressgateway-workload"
        if request.config.getoption("--service-mesh-type") == "ambient":
            istio_service = "istio-ingress-k8s-istio"
        url = get_public_url(lightkube_client, "kubeflow", istio_service)
        result_status, result_text = await fetch_response(url)
        assert result_status == 200
        assert "Log in to Your Account" in result_text
        assert "Email Address" in result_text
        assert "Password" in result_text


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


async def fetch_response(url, headers=None):
    """Fetch provided URL and return (status, text)."""
    result_status = 0
    result_text = ""
    async with aiohttp.ClientSession() as session:
        async with session.get(url=url, headers=headers) as response:
            result_status = response.status
            result_text = await response.text()
    return result_status, str(result_text)

import subprocess

import jubilant
import lightkube
import pytest
import requests
import tenacity
from itertools import batched
from lightkube.resources.core_v1 import Service


logging.getLogger("jubilant.wait").setLevel("WARNING")


@pytest.fixture()
def lightkube_client() -> lightkube.Client:
    client = lightkube.Client(field_manager="kubeflow")
    return client


class TestCharm:
    @pytest.mark.dependency()
    def test_apply_terraform_solution(self, juju: jubilant.Juju, tf_vars):
        """Initialize and apply the kubeflow-ambient Terraform solution module."""
        subprocess.run(["terraform", "init"], check=True)
        subprocess.run(
            [
                "terraform",
                "apply",
                "-auto-approve",
            ] + tf_vars,
            check=True,
        )

    @pytest.mark.dependency(depends=["TestCharm::test_apply_terraform_solution"])
    def test_assert_deployment(self, juju: jubilant.Juju, lightkube_client):
        """
        Wait for the applications to become active and idle and verify its public URL access.
        """

        apps = list(juju.status().apps.keys())

        # Remove opentelemetry-collector-k8s from the apps list because it remains
        # `blocked` until it's related to one of the COS charms
        if "opentelemetry-collector-k8s-kubeflow" in apps:
            apps.remove("opentelemetry-collector-k8s-kubeflow")

        for batched_apps in batched(apps, 5):
            juju.wait(lambda status: jubilant.all_active(status, *batched_apps), timeout=3600)

        # Verify deployment by checking the public URL
        url = get_public_url(lightkube_client, "kubeflow", "istio-ingress-k8s-istio")
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
def fetch_response(url, headers=None):
    """Fetch provided URL and return (status, text)."""
    response = requests.get(url, headers=headers)
    return response.status_code, response.text

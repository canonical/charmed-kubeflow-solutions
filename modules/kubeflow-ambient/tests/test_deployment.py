import subprocess

import aiohttp
import jubilant
import lightkube
import pytest
from lightkube.resources.core_v1 import Service


@pytest.fixture()
def lightkube_client() -> lightkube.Client:
    client = lightkube.Client(field_manager="kubeflow")
    return client


class TestCharm:
    @pytest.mark.dependency()
    async def test_apply_terraform_solution(self, juju: jubilant.Juju, tf_vars):
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
    async def test_assert_deployment(self, juju: jubilant.Juju, lightkube_client):
        """
        Wait for the applications to become active and idle and verify its public URL access.
        """

        apps = list(juju.status().apps.keys())

        # Remove opentelemetry-collector-k8s from the apps list because it remains
        # `blocked` until it's related to one of the COS charms
        apps.remove("opentelemetry-collector-k8s-kubeflow")

        juju.wait(lambda status: jubilant.all_active(status, *apps), timeout=3600)

        # Verify deployment by checking the public URL
        url = get_public_url(lightkube_client, "kubeflow")
        result_status, result_text = await fetch_response(url)
        assert result_status == 200
        assert "Log in to Your Account" in result_text
        assert "Email Address" in result_text
        assert "Password" in result_text


def get_public_url(lightkube_client: lightkube.Client, bundle_name: str):
    """Extracts public URL from service istio-ingressgateway-workload."""
    ingressgateway_svc = lightkube_client.get(
        Service, "istio-ingressgateway-workload", namespace=bundle_name
    )
    address = (
        ingressgateway_svc.status.loadBalancer.ingress[0].hostname
        or ingressgateway_svc.status.loadBalancer.ingress[0].ip
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

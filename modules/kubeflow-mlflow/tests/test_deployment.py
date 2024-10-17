import subprocess

import aiohttp
import lightkube
import pytest
from lightkube.resources.core_v1 import Service
from pytest_operator.plugin import OpsTest


@pytest.fixture()
def lightkube_client() -> lightkube.Client:
    client = lightkube.Client(field_manager="kubeflow")
    return client


class TestCharm:

    @pytest.mark.dependency()
    async def test_apply_terraform_solution(self):
        """Initialize and apply the kubeflow-mlflow Terraform solution module."""
        subprocess.run(["terraform", "init"], check=True )
        # Due to https://github.com/canonical/mysql-k8s-operator/issues/504,
        # we need to pin instances of mysql-k8s (using the one from 8.0/beta).
        # Otherwise, mysql will error out with COS configuration enabled.
        subprocess.run(["terraform", "apply",
                         "-var", "cos_configuration=true",
                         "-var", "kfp_db_revision=203",
                         "-var", "katib_db_revision=203",
                         "-var", "mlflow_mysql_revision=203",
                         "-auto-approve"], check=True)


    @pytest.mark.dependency(depends=["TestCharm::test_apply_terraform_solution"])
    async def test_assert_deployment(
        self, ops_test: OpsTest, lightkube_client
    ):
        """
        Wait for the applications to become active and idle and verify its public URL access.
        """

        # We cannot wait the model because grafana-agent-k8s
        # remains blocked until it's related to one of the COS charms
        # Thus we define all charms deployed by the solution except this.
        await ops_test.model.wait_for_idle(
            apps=[
                "admission-webhook",
                "argo-controller",
                "dex-auth",
                "envoy",
                "istio-ingressgateway",
                "istio-pilot",
                "jupyter-controller",
                "jupyter-ui",
                "katib-controller",
                "katib-db",
                "katib-db-manager",
                "katib-ui",
                "kfp-api",
                "kfp-db",
                "kfp-metadata-writer",
                "kfp-persistence",
                "kfp-profile-controller",
                "kfp-schedwf",
                "kfp-ui",
                "kfp-viewer",
                "kfp-viz",
                "knative-eventing",
                "knative-operator",
                "knative-serving",
                "kserve-controller",
                "kubeflow-dashboard",
                "kubeflow-profiles",
                "kubeflow-roles ",
                "kubeflow-volumes",
                "metacontroller-operator",
                "minio",
                "mlflow-minio",
                "mlflow-mysql",
                "mlflow-server",
                "mlmd",
                "oidc-gatekeeper",
                "pvcviewer-operator",
                "resource-dispatcher",
                "tensorboard-controller",
                "tensorboards-web-app",
                "training-operator"
            ],
            status="active",
            raise_on_blocked=False,
            raise_on_error=False,
            timeout=1500,
        )

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

import jubilant
import pytest

MODEL_NAME = "kubeflow"

@pytest.fixture(scope="module")
def juju():
    juju_instance = jubilant.Juju()
    juju_instance.add_model(MODEL_NAME)

    yield juju_instance

def pytest_addoption(parser):
    """Add CLI options to pytest."""
    parser.addoption(
        "--istio-k8s-platform",
        nargs="?",
        default="microk8s",
        type=str,
        help="Platform for istio-k8s (e.g., microk8s, or empty string for Canonical K8s)",
    )
    parser.addoption(
        "--service-mesh-type",
        nargs="?",
        default="sidecar",
        choices=["sidecar", "ambient"],
        type=str,
        help="Service mesh type (sidecar or ambient)",
    )
    parser.addoption(
        "--risk",
        nargs="?",
        choices=["stable", "candidate", "beta", "edge"],
        default="edge",
        type=str,
        help="Risk to be used when deploying the terraform module",
    )

@pytest.fixture(scope="module")
def service_mesh_type(request) -> list[str]:
    """Terraform module customization for the db sizes."""
    istio_mode = request.config.getoption("--service-mesh-type")
    return [
        "-var", f"service_mesh_type={istio_mode}",
    ]

@pytest.fixture(scope="module")
def risk(request) -> list[str]:
    """Terraform module customization for the risk."""
    risk = request.config.getoption("--risk") or "edge"
    return ["-var", f"risk={risk}"]

@pytest.fixture(scope="module")
def tf_vars(risk) -> list[str]:
    """Overall Terraform module customization."""
    return risk + [
        "-var", "create_model=false",
    ]

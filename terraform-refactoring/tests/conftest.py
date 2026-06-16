import jubilant
import pytest

from dotenv import load_dotenv
import os

MODEL_NAME = "kubeflow"

load_dotenv()

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
    parser.addoption(
        "--enable-mlflow",
        action="store_true",
        help="Enable to deploy also mlflow",
    )
    parser.addoption(
        "--enable-feast",
        action="store_true",
        help="Enable to deploy also Feast",
    )
    parser.addoption(
        "--enable-spark",
        action="store_true",
        help="Enable to deploy also Spark",
    )


@pytest.fixture(scope="module")
def service_mesh_type(request) -> list[str]:
    """Terraform module customization for the db sizes."""
    istio_mode = request.config.getoption("--service-mesh-type")
    return [
        "-var",
        f"service_mesh_type={istio_mode}",
    ]


@pytest.fixture(scope="module")
def risk(request) -> list[str]:
    """Terraform module customization for the risk."""
    risk = request.config.getoption("--risk") or "edge"
    return ["-var", f"risk={risk}"]


@pytest.fixture(scope="module")
def enable_mlflow(request) -> list[str]:
    """Terraform module customization for MLFlow deployment."""
    if request.config.getoption("--enable-mlflow"):
        return ["-var", "enable_mlflow=true"]
    return []

@pytest.fixture(scope="module")
def enable_feast(request) -> list[str]:
    """Terraform module customization for Feast deployment."""
    if request.config.getoption("--enable-feast"):
        return ["-var", "enable_feast=true"]
    return []

@pytest.fixture(scope="module")
def enable_spark(request) -> list[str]:
    """Terraform module customization for Spark deployment."""
    if request.config.getoption("--enable-spark"):        
        extra_args = [
            "-var", "enable_spark=true", 
            "-var", "s3_bucket=spark-demo",
            "-var", f"s3_secret_key={os.environ.get('S3_SECRET_KEY')}",
            "-var", f"s3_access_key={os.environ.get('S3_ACCESS_KEY')}",
            "-var", f"s3_endpoint={os.environ.get('S3_SERVER_URL')}",
        ]
        print(f"Extra args for Spark deployment: {extra_args}")
        return extra_args
    return []

@pytest.fixture(scope="module")
def tf_vars(risk, service_mesh_type, enable_mlflow, enable_feast, enable_spark) -> list[str]:
    """Overall Terraform module customization."""
    return (
        enable_mlflow
        + enable_feast
        + enable_spark
        + service_mesh_type
        + risk
        + [
            "-var",
            "create_model=false",
        ]
    )

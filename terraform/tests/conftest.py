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
        default="",
        type=str,
        help="Platform for istio-k8s (e.g., microk8s, or empty string for Canonical K8s)",
    )
    parser.addoption(
        "--service-mesh-type",
        nargs="?",
        default="sidecar",
        choices=["sidecar", "ambient"],
        type=str,
        help="Service mesh type (sidecar, ambient)",
    )
    parser.addoption(
        "--auth-type",
        nargs="?",
        default="dex",
        choices=["dex", "iam"],
        type=str,
        help="Authentication stack (dex, iam)",
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
    parser.addoption(
        "--istio-cni-bin-dir",
        nargs="?",
        const="",
        default="",
        type=str,
        help="Directory of binaries for Istio CNI",
    )
    parser.addoption(
        "--istio-cni-conf-dir",
        nargs="?",
        const="",
        default="",
        type=str,
        help="Directory of configurations for Istio CNI",
    )
    parser.addoption(
        "--pss",
        nargs="?",
        choices=["privileged", "baseline"],
        const="privileged",
        default="privileged",
        type=str,
        help="Pod security standards enforced in Profiles' namespaces",
    )


@pytest.fixture(scope="module")
def pss(request) -> list[str]:
    """Pod security standards enforced in Profiles' namespaces."""
    pss = request.config.getoption("--pss")
    istio_cni_bin_dir = request.config.getoption("--istio-cni-bin-dir") or ""
    istio_cni_conf_dir = request.config.getoption("--istio-cni-conf-dir") or ""
    return [
        "-var",
        f"istio_cni_bin_dir={istio_cni_bin_dir}",
        "-var",
        f"istio_cni_conf_dir={istio_cni_conf_dir}",
        "-var",
        f"kubeflow_profiles_security_policy={pss}",
    ]


@pytest.fixture(scope="module")
def istio_k8s_platform(request) -> list[str]:
    """Terraform module customization for the istio-k8s platform."""
    platform = request.config.getoption("--istio-k8s-platform") or ""
    return ["-var", f"istio_k8s_platform={platform}"]


@pytest.fixture(scope="module")
def service_mesh_type(request) -> list[str]:
    """Terraform module customization for the service mesh type."""
    mesh = request.config.getoption("--service-mesh-type")
    return ["-var", f"service_mesh_type={mesh}"]


@pytest.fixture(scope="module")
def auth_type(request) -> list[str]:
    """Terraform module customization for the authentication stack."""
    auth = request.config.getoption("--auth-type")
    return ["-var", f"auth_type={auth}"]


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
            "-var",
            "enable_spark=true",
            "-var",
            f"s3_bucket={os.environ['S3_BUCKET']}",
            "-var",
            f"s3_secret_key={os.environ['S3_SECRET_KEY']}",
            "-var",
            f"s3_access_key={os.environ['S3_ACCESS_KEY']}",
            "-var",
            f"s3_endpoint={os.environ['S3_SERVER_URL']}",
        ]
        print(f"Extra args for Spark deployment: {extra_args}")
        return extra_args
    return []


@pytest.fixture(scope="module")
def solution_module_path(request) -> str:
    """Path to the Terraform root module to apply for the selected auth stack."""
    if request.config.getoption("--auth-type") == "iam":
        return "./../tests/kubeflow-ambient-iam"
    return "./../products/kubeflow"


@pytest.fixture(scope="module")
def tf_vars(
    request,
    risk,
    service_mesh_type,
    auth_type,
    istio_k8s_platform,
    enable_mlflow,
    enable_feast,
    enable_spark,
    pss,
) -> list[str]:
    """Overall Terraform module customization."""
    if request.config.getoption("--auth-type") == "iam":
        # The kubeflow-ambient-iam root always deploys ambient + iam and lets
        # Terraform create the istio-system, iam and iam-core models. Only the
        # kubeflow model is pre-created by the test and referenced via model_uuid.
        return (
            enable_mlflow
            + enable_feast
            + istio_k8s_platform
            + risk
            + [
                "-var",
                "create_model=false",
                "-var",
                "external_ui_hostname=ui.kubeflow.com",
                "-var",
                "external_m2m_hostname=api.kubeflow.com",
                "-var",
                "external_auth_hostname=auth.kubeflow.com",
            ]
        )
    return (
        enable_mlflow
        + enable_feast
        + enable_spark
        + service_mesh_type
        + auth_type
        + istio_k8s_platform
        + risk
        + pss
        + [
            "-var",
            "create_model=false",
            "-var",
            "mysql_storage_size=1G",
            "-var",
            "minio_storage_size=10G",
            "-var",
            "mlmd_storage_size=10G",
            "-var",
            "postgresql_storage_size=1G",
        ]
    )

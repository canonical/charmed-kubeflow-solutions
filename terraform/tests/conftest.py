import jubilant
import pytest

from constants import AUTH_HOSTNAME, M2M_HOSTNAME, UI_HOSTNAME
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
            f"s3_bucket_spark={os.environ['S3_BUCKET_SPARK']}",
            "-var",
            f"s3_secret_key_spark={os.environ['S3_SECRET_KEY_SPARK']}",
            "-var",
            f"s3_access_key_spark={os.environ['S3_ACCESS_KEY_SPARK']}",
            "-var",
            f"s3_endpoint_spark={os.environ['S3_SERVER_URL_SPARK']}",
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
def setup_s3_integrator_global() -> list[str]:
    """Terraform module customization for the shared S3 integrator."""
    args = [
        "-var",
        f"s3_bucket_global={os.environ['S3_BUCKET_KFP_GLOBAL']}",
        "-var",
        f"s3_secret_key_global={os.environ['S3_SECRET_KEY_GLOBAL']}",
        "-var",
        f"s3_access_key_global={os.environ['S3_ACCESS_KEY_GLOBAL']}",
        "-var",
        f"s3_endpoint_global={os.environ['S3_SERVER_URL_GLOBAL']}",
    ]
    print(f"Args for shared S3 integration: {args}")
    return args


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
    setup_s3_integrator_global,
) -> list[str]:
    """Overall Terraform module customization."""
    if request.config.getoption("--auth-type") == "iam":
        # The kubeflow-ambient-iam root always deploys ambient + iam and lets
        # Terraform create the istio-system, iam and iam-core models. Only the
        # kubeflow model is pre-created by the test and referenced via model_uuid.

        # Validate that the service mesh type is ambient, as required by the IAM auth stack.
        service_mesh = request.config.getoption("--service-mesh-type")
        if service_mesh != "ambient":
            raise ValueError(
                "--auth-type=iam requires --service-mesh-type=ambient; "
                f"got {service_mesh!r}"
            )
        return (
            enable_mlflow
            + enable_feast
            + istio_k8s_platform
            + risk
            + setup_s3_integrator_global
            + [
                "-var",
                "create_model=false",
                "-var",
                "object_storage_mode=S3",
                "-var",
                f"external_ui_hostname={UI_HOSTNAME}",
                "-var",
                f"external_m2m_hostname={M2M_HOSTNAME}",
                "-var",
                f"external_auth_hostname={AUTH_HOSTNAME}",
                "-var",
                (
                    "github_profiles_automator_config={"
                    'repository="https://github.com/canonical/github-profiles-automator.git",'
                    '"pmr-yaml-path"="tests/samples/pmr-sample-full.yaml",'
                    # Pin to a revision tag for reproducibility.
                    '"git-revision"="rev295",'
                    # Slow the reconcile so it does not remove the m2m UATs'
                    # directly-created authorization mid-run.
                    '"sync-period"="86400"}'
                ),
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
        + setup_s3_integrator_global
        + [
            "-var",
            "create_model=false",
            "-var",
            "object_storage_mode=S3",
            "-var",
            "mysql_storage_size=1G",
            "-var",
            "mlmd_storage_size=10G",
            "-var",
            "postgresql_storage_size=1G",
            "-var",
            "release=latest",
        ]
    )

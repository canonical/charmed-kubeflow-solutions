# tests/integration/conftest.py

import jubilant
import pytest

MODEL_NAME = "kubeflow"

@pytest.fixture(scope="module")
def juju(request: pytest.FixtureRequest):
    
    def print_debug_log(juju_instance: jubilant.Juju):
        if request.session.testsfailed:
            print(f"[DEBUG] Fetching debug log for model: {juju_instance.model}")
            log = juju_instance.debug_log(limit=1000)
            print(log, end="")

    juju_instance = jubilant.Juju()
    juju_instance.add_model(MODEL_NAME)

    try:
        yield juju_instance
    finally:
        print_debug_log(juju_instance)

def pytest_addoption(parser):
    """Add CLI options to pytest."""
    parser.addoption(
        "--istio-k8s-platform",
        nargs="?",
        const="",
        default="microk8s",
        type=str,
        help="Platform for istio-k8s (e.g., k8s, microk8s, or empty string for Canonical K8s)",
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
    parser.addoption(
        "--db-size",
        default="1G",
        type=str,
        help="Size to be used for the databases.",
    )

@pytest.fixture(scope="module")
def db_sizes(request) -> list[str]:
    """Terraform module customization for the db sizes."""
    size = request.config.getoption("--db-size") or "1G"
    return [
        "-var", f"kfp_db_size={size}",
        "-var", f"katib_db_size={size}",
        "-var", f"opentelemetry_collector_k8s_size={size}",
        "-var", f"feast_registry_size={size}",
        "-var", f"feast_online_store_size={size}",
    ]

@pytest.fixture(scope="module")
def pss(request) -> list[str]:
    """Pod security standards enforced in Profiles' namespaces."""
    pss = request.config.getoption("--pss")
    istio_k8s_platform = request.config.getoption("--istio-k8s-platform")
    if istio_k8s_platform is None:
        istio_k8s_platform = "microk8s"
    return [
        "-var",
        f"istio_k8s_platform={istio_k8s_platform}",
        "-var",
        f"kubeflow_profiles_security_policy={pss}",
    ]

@pytest.fixture(scope="module")
def tf_vars(request, db_sizes, pss) -> list[str]:
    """Overall Terraform module customization."""
    return db_sizes + pss + [
        "-var", "create_model=false",
        "-var", "cos_configuration=true",
    ]

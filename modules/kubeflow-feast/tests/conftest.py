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
        "--risk",
        nargs="?",
        choices=["stable", "candidate", "beta", "edge"],
        const="stable",
        default="stable",
        type=str,
        help="Risk to be used when deploying the terraform module",
    )
    parser.addoption(
        "--db-size",
        default="1G",
        type=str,
        help="Size to be used for the databases.",
    )

@pytest.fixture(scope="module")
def risk(request) -> list[str]:
    """Terraform module customization for the risk."""
    risk = request.config.getoption("--risk") or "stable"
    return ["-var", f"risk={risk}"]

@pytest.fixture(scope="module")
def db_sizes(request) -> list[str]:
    """Terraform module customization for the db sizes."""
    size = request.config.getoption("--db-size") or "1G"
    return [
        "-var", f"kfp_db_size={size}",
        "-var", f"katib_db_size={size}",
        "-var", f"grafana_agent_k8s_size={size}",
    ]

@pytest.fixture(scope="module")
def tf_vars(request, risk, db_sizes) -> list[str]:
    """Overall Terraform module customization."""
    return risk +  db_sizes

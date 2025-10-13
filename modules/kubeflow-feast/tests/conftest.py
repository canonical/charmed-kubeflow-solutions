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

@pytest.fixture(scope="module")
def risk(request) -> str:
    """The risk to be used when deploying the terraform module."""
    return request.config.getoption("--risk") or "stable"

import pytest

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

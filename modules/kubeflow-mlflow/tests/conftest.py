import pytest

def pytest_addoption(parser):
    """Add CLI options to pytest."""
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
def istio_cni_bin_dir(request) -> str:
    """Directory of binaries for Istio CNI."""
    return request.config.getoption("--istio-cni-bin-dir")

@pytest.fixture(scope="module")
def istio_cni_conf_dir(request) -> str:
    """Directory of configurations for Istio CNI."""
    return request.config.getoption("--istio-cni-conf-dir")

@pytest.fixture(scope="module")
def pss(request) -> str:
    """Pod security standards enforced in Profiles' namespaces."""
    return request.config.getoption("--pss")

@pytest.fixture(scope="module")
def risk(request) -> str:
    """The risk to be used when deploying the terraform module."""
    return request.config.getoption("--risk") or "stable"

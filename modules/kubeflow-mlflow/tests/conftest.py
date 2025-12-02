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
        "-var", f"mlflow_mysql_size={size}",
        "-var", f"grafana_agent_k8s_size={size}",
    ]

@pytest.fixture(scope="module")
def pss(request) -> list[str]:
    """Pod security standards enforced in Profiles' namespaces."""
    pss = request.config.getoption("--pss")
    istio_cni_bin_dir = request.config.getoption("--istio-cni-conf-dir") or ""
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
def tf_vars(request, risk, db_sizes, pss) -> list[str]:
    """Overall Terraform module customization."""
    return risk + db_sizes + pss + [
        "-var", "cos_configuration=true",
        "-var", "kubeflow_trainer_v2=true",
    ]

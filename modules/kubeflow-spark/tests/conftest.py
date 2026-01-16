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
    parser.addoption(
        "--tf-vars-file",
        nargs="?",
        const="",
        default="",
        type=str,
        help="Custom TF vars for the terraform module.",
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
        "-var", f"opentelemetry_collector_k8s_size={size}",
    ]

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
def kf_spark_vars(request) -> list[str]:
    """Terraform module customization for the Kubeflow Spark module."""
    return [
        "-var", "metacontroller_operator_revision=551",
        "-var", "resource_dispatcher_revision=410",
    ]

@pytest.fixture(scope="module")
def tf_vars_file(request) -> list[str]:
    """Custom TF vars for the terraform module."""
    tfvars_file = request.config.getoption("--tf-vars-file")
    if tfvars_file:
        return ["-var-file", tfvars_file]
    return []

@pytest.fixture(scope="module")
def tf_vars(risk, pss, db_sizes, kf_spark_vars, tf_vars_file) -> list[str]:
    """Overall Terraform module customization."""
    return risk + pss + db_sizes + kf_spark_vars + [
        "-var", "cos_configuration=true",
    ] + tf_vars_file

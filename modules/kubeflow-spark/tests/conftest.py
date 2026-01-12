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
def kf_spark_vars(request) -> list[str]:
    """Terraform module customization for the Kubeflow Spark module."""
    return [
        "-var", "metacontroller_operator_revision=551",
        "-var", "resource_dispatcher_revision=410",
    ]

@pytest.fixture(scope="module")
def tf_vars(request, risk, db_sizes, kf_spark_vars) -> list[str]:
    """Overall Terraform module customization."""
    return risk + db_sizes + kf_spark_vars + [
        "-var", "cos_configuration=true",
    ]

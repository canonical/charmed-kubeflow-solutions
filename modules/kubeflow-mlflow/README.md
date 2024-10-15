# Charmed Kubeflow + MLflow Terraform solution


This is a Terraform module facilitating the deployment and integration of Charmed Kubeflow and MLflow, using the [Terraform juju provider](https://github.com/juju/terraform-provider-juju/). For more information, refer to the provider [documentation](https://registry.terraform.io/providers/juju/juju/latest/docs). 

## API

### Inputs
The solution module offers the following configurable inputs:

| Name | Type | Description | Required |
| - | - | - | - |
| `<charm_name>_revision`| number | For each charm of the solution, the revision of the charm to deploy | False |
| `cos_configuration`| bool | Boolean value that enables COS configuration | False |
| `dex_connectors`| string | dex-auth connectors in yaml format | False |
| `dex_static_username`| string | dex-auth static username | False |
| `dex_static_password`| string | dex-auth static password | False |
| `grafana_agent_k8s_size`| string | Grafana agent database storage size | False |
| `http_proxy`| string | Value of the http_proxy environment variable | False |
| `https_proxy`| string | Value of the https_proxy environment variable | False |
| `istio_tls_secret_id`| string | The juju secret id for the tls key/cert for istio-pilot | False |
| `jupyter_ui_config`| map(string) | Map of config values passed to jupyter-ui | False |
| `katib_db_size`| string | Katib database storage size | False |
| `kfp_db_size`| string | KFP database storage size | False |
| `minio_size`| string | MinIO database storage size | False |
| `mlflow_kserve_integration` | bool | Boolean value that integrates MLflow with KServe | False |
| `mlflow_minio_size`         | string | MinIO storage size allocation            | False    |
| `mlflow_mysql_size`  | string | MySQL storage size allocation for MLflow | False    |
| `mlmd_size`| string | MLMD database storage size | False |
| `no_proxy`| string | Value of the no_proxy environment variable | False |
| `public_url`| string | Public URL of Kubeflow for auth/OIDC | False |

### Outputs
Upon applied, the solution module exports the following outputs:

| Name | Description |
| - | - |
| `grafana_agent_k8s`| Map containing the `app_name`, `provides` and `requires` endpoints of the grafana-agent-k8s charm used |
| `model`|  Model name that Charmed Kubeflow and MLflow are deployed on |
| `tls_certificate_requirer`|  Map containing the `app_name` and the `requires` TLS endpoint of the TLS requirer charm |

## Usage

This solution module is intended to be used either on its own or as part of a higher-level module. 

### Model
This solution always creates a model of the name `kubeflow`, since Charmed Kubeflow cannot be deployed in a different model.

### COS configuration

#### Enable COS configuration
The `cos_configuration` input enables the solution to configure Charmed Kubeflow and MLflow to integrate with COS. This is done by deploying a `grafana-agent-k8s` charm and adding all the required relations.
```
terraform apply -var cos_configuration=true
```

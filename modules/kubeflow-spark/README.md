# Charmed Kubeflow + Charmed Spark Terraform solution

> [!WARNING]
> This feature is experimental and therefore should not be used in production.


This is a Terraform module facilitating the deployment and integration of Charmed Kubeflow and Spark, using the [Terraform juju provider](https://github.com/juju/terraform-provider-juju/). For more information, refer to the provider [documentation](https://registry.terraform.io/providers/juju/juju/latest/docs). 

## API

### Inputs
The solution module offers the following configurable inputs:

| Name | Type | Description | Required |
| - | - | - | - |
| `<charm_name>_revision`| number | For each charm of the solution, the revision of the charm to deploy | False |
| `risk`| string | Value for the risk to be used. Valid values are (stable, candidate, beta and edge)   | False |
| `create_model` | bool | Allows to skip Juju model creation and re-use a model created in a higher level module. When re-using a model, if this is created by Terraform, make sure that the current module depends on the resource using the `depends_on` option. | False |
| `cos_configuration`| bool | Boolean value that enables COS configuration | False |
| `dex_connectors`| string | dex-auth connectors in yaml format | False |
| `dex_static_username`| string | dex-auth static username | False |
| `dex_static_password`| string | dex-auth static password | False |
| `existing_opentelemetry_collector_name`| string | Name of an existing opentelemetry-collector-k8s deployment | False |
| `opentelemetry_collector_k8s_size`| string | OpenTelemetry collector storage size | False |
| `http_proxy`| string | Value of the http_proxy environment variable | False |
| `https_proxy`| string | Value of the https_proxy environment variable | False |
| `istio_tls_secret_id`| string | The juju secret id for the tls key/cert for istio-pilot | False |
| `jupyter_ui_config`| map(string) | Map of config values passed to jupyter-ui | False |
| `katib_db_size`| string | Katib database storage size | False |
| `kfp_db_size`| string | KFP database storage size | False |
| `minio_size`| string | MinIO database storage size | False |
| `mlmd_size`| string | MLMD database storage size | False |
| `no_proxy`| string | Value of the no_proxy environment variable | False |
| `public_url`| string | Public URL of Kubeflow for auth/OIDC | False |

### Outputs
Upon applied, the solution module exports the following outputs:

| Name | Description |
| - | - |
| `opentelemetry_collector_k8s`| Map containing the `app_name`, `provides` and `requires` endpoints of the opentelemetry-collector-k8s charm used |
| `model`|  Model name that Charmed Kubeflow and MLflow are deployed on |
| `resource_dispatcher`|  Map containing the `app_name`, `provides` and `requires` fields of the resource-dispatcher charm |
| `tls_certificate_requirer`|  Map containing the `app_name` and the `requires` TLS endpoint of the TLS requirer charm |

## Usage

This solution module is intended to be used either on its own or as part of a higher-level module. 

### Model
This solution always creates a model of the name `kubeflow`, since Charmed Kubeflow cannot be deployed in a different model.


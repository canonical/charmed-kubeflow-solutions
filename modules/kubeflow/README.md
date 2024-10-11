# Charmed Kubeflow Terraform solution


This is a Terraform module facilitating the deployment of Charmed Kubeflow, using the [Terraform juju provider](https://github.com/juju/terraform-provider-juju/). For more information, refer to the provider [documentation](https://registry.terraform.io/providers/juju/juju/latest/docs). 

## API

### Inputs
The solution module offers the following configurable inputs:

| Name | Type | Description | Required |
| - | - | - | - |
| `<charm_name>_revision`| number | For each charm of the solution, the revision of the charm to deploy | False |
| `cos_configuration`| bool | Boolean value that enables COS configuration | False |
| `create_model`| bool | Allows to skip Juju model creation and re-use a model created in a higher level module | False |
| `dex_connectors`| string | dex-auth connectors in yaml format | False |
| `existing_grafana_agent_name`| string | Name of an existing grafana-agent-k8s deployment | False |
| `grafana_agent_k8s_size`| string | Grafana agent database storage size | False |
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
| `grafana_agent_k8s`| Map containing the `app_name`, `provides` and `requires` endpoints of the grafana-agent-k8s charm used |
| `model_name`|  Model name that Charmed Kubeflow is deployed on |
| `tls_certificate_requirer`|  Map containing the `app_name` and the `requires` TLS endpoint of the TLS requirer charm |

## Usage

This solution module is intended to be used either on its own or as part of a higher-level module. 

### Create model
If `kubeflow` model is created outside of this solution module (ie in a higher-level module), then this should be deployed with `create_model` set to `false`.
```
terraform apply -var create_model=false
```
By default, it is set to `true` in order to enable the Charmed Kubeflow's standalone deployment. Note also that this takes into account that Kubeflow can be deployed only to a namespace called `kubeflow`.

### COS configuration

#### Enable COS configuration
The `cos_configuration` input enables the solution to configure Charmed Kubeflow to integrate with COS. This is done by deploying a `grafana-agent-k8s` charm and adding all the required relations.
```
terraform apply -var cos_configuration=true
```

#### Use an existing grafana-agent-k8s
If there is already an instance of the grafana-agent-k8s charm in the `kubeflow` model, then it can be used instead of deploying a new one. This is achieved with the use of `existing_grafana_agent_name` input. By default, its value is `null`.
```
terraform apply -var cos_configuration=true -var existing_grafana_agent_name="dummy-grafana-agent"
```
> :warning: Setting this input without `cos_configuration` will not have any effect.


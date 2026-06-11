# Charmed Kubeflow Ambient Terraform solution

> **⚠️ WARNING: EXPERIMENTAL** 
> 
> This solution is experimental and currently deploys charms from the `latest/edge` channel. It is **NOT recommended for production use**.

This is a Terraform module facilitating the deployment of Charmed Kubeflow in ambient mode, using the [Terraform juju provider](https://github.com/juju/terraform-provider-juju/). For more information, refer to the provider [documentation](https://registry.terraform.io/providers/juju/juju/latest/docs). 

The ambient mode provides an alternative deployment of Kubeflow that includes all core components along with KServe for model serving capabilities.

## API

### Inputs
The solution module offers the following configurable inputs:

| Name | Type | Description | Required |
| - | - | - | - |
| `<charm_name>_revision`| number | For each charm of the solution, the revision of the charm to deploy | False |
| `argo_controller_bucket`| string | The name of the bucket to be used by Argo controller in the object store | False |
| `cos_configuration`| bool | Boolean value that enables COS configuration | False |
| `create_model`| bool | Allows to skip Juju model creation and re-use a model created in a higher level module | False |
| `dex_connectors`| string | dex-auth connectors in yaml format | False |
| `dex_static_password`| string | dex-auth static password | False |
| `dex_static_username`| string | dex-auth static username value | False |
| `existing_opentelemetry_collector_name`| string | Name of an existing opentelemetry-collector-k8s deployment | False |
| `http_proxy`| string | Value of the http_proxy environment variable | False |
| `https_proxy`| string | Value of the https_proxy environment variable | False |
| `istio_k8s_platform`| string | Platform for istio-k8s | False |
| `jupyter_ui_config`| map(string) | Map of config values passed to jupyter-ui | False |
| `katib_db_size`| string | Katib database storage size | False |
| `kfp_api_object_store_bucket_name`| string | The name of the bucket to be used by KFP API in the object store | False |
| `kfp_db_size`| string | KFP database storage size | False |
| `kubeflow_dashboard_registration_flow`| string | Whether to enable the registration flow on sign-in for kubeflow-dashboard | False |
| `kubeflow_profiles_security_policy`| string | Security policy for pod security standards enforced in user workloads. Only `privileged` and `baseline` are supported | False |
| `kubeflow_trainer_v2`| bool | Boolean value that enables deployment of Kubeflow Trainer V2 (experimental) | False |
| `minio_access_key`| string | MinIO access key | False |
| `minio_gateway_storage_service`| string | Gateway storage service configuration for MinIO when in 'gateway' mode | False |
| `minio_mode`| string | MinIO mode, either 'server' or 'gateway' | False |
| `minio_secret_key`| string | MinIO secret key | False |
| `minio_size`| string | MinIO database storage size | False |
| `minio_storage_service_endpoint`| string | MinIO storage service endpoint, required if minio_mode is 'gateway' | False |
| `mlmd_size`| string | MLMD database storage size | False |
| `no_proxy`| string | Value of the no_proxy environment variable | False |
| `oidc_gatekeeper_ca_bundle`| string | Custom CA to be trusted by OIDC gatekeeper | False |
| `opentelemetry_collector_k8s_size`| string | OpenTelemetry collector storage size | False |
| `public_url`| string | Public URL of Kubeflow for auth/OIDC | False |
| `risk`| string | Value for the risk to be used | False |
### Outputs
Upon applied, the solution module exports the following outputs:

| Name | Description |
| - | - |
| `dashboard_links_provider`| Map containing the `app_name` and `provides` endpoints of the kubeflow-dashboard charm |
| `kserve_controller`| Map containing the `app_name`, `provides` and `requires` fields of the kserve-controller charm |
| `opentelemetry_collector_k8s`| Map containing the `app_name`, `provides` and `requires` endpoints of the opentelemetry-collector-k8s charm used |
| `model`|  Model name that Charmed Kubeflow is deployed on |

## Usage

This solution module is intended to be used either on its own or as part of a higher-level module. 

### Model
This solution always creates a model of the name `kubeflow`, since Charmed Kubeflow cannot be deployed in a different model.

### COS configuration

#### Enable COS configuration
The `cos_configuration` input enables the solution to configure Charmed Kubeflow to integrate with COS. This is done by deploying a `opentelemetry-collector-k8s` charm and adding all the required relations.
```
terraform apply -var cos_configuration=true
```

#### Use an existing opentelemetry-collector-k8s
If there is already an instance of the opentelemetry-collector-k8s charm in the `kubeflow` model, then it can be used instead of deploying a new one. This is achieved with the use of `existing_opentelemetry_collector_name` input. By default, its value is `null`.
```
terraform apply -var cos_configuration=true -var existing_opentelemetry_collector_name="dummy-opentelemetry-collector"
```
> :warning: Setting this input without `cos_configuration` will not have any effect.

### Kubeflow Trainer V2

#### Enable Kubeflow Trainer V2 (Experimental)
The `kubeflow_trainer_v2` input enables the solution to deploy Kubeflow Trainer V2 charm and all the required resources.
```shell
terraform apply -var kubeflow_trainer_v2=true
```

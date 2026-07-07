# Charmed Kubeflow + MLflow Terraform solution


This is a Terraform module facilitating the deployment and integration of Charmed Kubeflow and MLflow, using the [Terraform juju provider](https://github.com/juju/terraform-provider-juju/). For more information, refer to the provider [documentation](https://registry.terraform.io/providers/juju/juju/latest/docs). 

## API

### Inputs
The solution module offers the following configurable inputs:

| Name | Type | Description | Required |
| - | - | - | - |
| `<charm_name>_revision`| number | For each charm of the solution, the revision of the charm to deploy | False |
| `argo_controller_bucket`| string | The name of the bucket to be used by Argo controller in the object store | False |
| `cos_configuration`| bool | Boolean value that enables COS configuration | False |
| `create_model`| bool | Allows to skip Juju model creation and re-use a model created in a higher level module. When re-using a model, if this is created by Terraform, make sure that the current module depends on the resource using the depends_on option. | False |
| `dex_connectors`| string | dex-auth connectors in yaml format | False |
| `dex_static_password`| string | dex-auth static password | False |
| `dex_static_username`| string | dex-auth static username value | False |
| `enable_mlflow_nodeport`| bool | Boolean value that enables the NodePort service for MLflow | False |
| `existing_opentelemetry_collector_name`| string | Name of an existing opentelemetry-collector-k8s deployment | False |
| `http_proxy`| string | Value of the http_proxy environment variable | False |
| `https_proxy`| string | Value of the https_proxy environment variable | False |
| `istio_cni_bin_dir`| string | Path to CNI binaries, e.g. /opt/cni/bin. If not provided, the Istio control plane will be installed/upgraded with the Istio CNI plugin disabled. This path depends on the Kubernetes installation, please refer to https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/ for information to find out the correct path. | False |
| `istio_cni_conf_dir`| string | Path to conflist files describing the CNI configuration, e.g. /etc/cni/net.d. If not provided, the Istio control plane will be installed/upgraded with the Istio CNI plugin disabled. This path depends on the Kubernetes installation, please refer to https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/ for information to find out the correct path. | False |
| `istio_ingressgateway_annotations`| string | A comma-separated list of annotations to apply to the Ingress Service to enable customisation for cloud providers or integrations. | False |
| `istio_tls_secret_id`| string | The juju secret id for the tls key/cert for istio-pilot | False |
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
| `mlflow_dashboard_link`| bool | Boolean value that enables MLflow link in Kubeflow's dashboard | False |
| `mlflow_default_artifact_root`| string | The default bucket MLflow uses for artifacts | False |
| `mlflow_kserve_integration`| bool | Boolean value that enables MLflow-KServe configuration | False |
| `mlflow_minio_access_key`| string | MinIO access key for MLflow | False |
| `mlflow_minio_gateway_storage_service`| string | Gateway storage service configuration for MinIO when in 'gateway' mode for MLflow | False |
| `mlflow_minio_mode`| string | MinIO mode for MLflow, either 'server' or 'gateway' | False |
| `mlflow_minio_secret_key`| string | MinIO secret key for MLflow | False |
| `mlflow_minio_size`| string | MinIO database storage size | False |
| `mlflow_minio_storage_service_endpoint`| string | MinIO storage service endpoint for MLflow, required if mlflow_minio_mode is 'gateway' | False |
| `mlflow_mysql_size`| string | Size allocated for mysql data | False |
| `mlflow_nodeport`| number | The nodeport for MLflow | False |
| `mlmd_size`| string | MLMD database storage size | False |
| `model_name`| string | Name of the Juju model/Kubernetes namespace used for the Kubeflow deployment | False |
| `no_proxy`| string | Value of the no_proxy environment variable | False |
| `oidc_gatekeeper_ca_bundle`| string | Custom CA to be trusted by OIDC gatekeeper | False |
| `opentelemetry_collector_k8s_size`| string | OpenTelemetry collector storage size | False |
| `public_url`| string | Public URL of Kubeflow for auth/OIDC. The default 'null' value results in a dex-auth URL that references the deployment namespace within it's FQDN | False |
| `risk`| string | Value for the risk to be used | False |
### Outputs
Upon applied, the solution module exports the following outputs:

| Name | Description |
| - | - |
| `opentelemetry_collector_k8s`| Map containing the `app_name`, `provides` and `requires` endpoints of the opentelemetry-collector-k8s charm used |
| `model`|  Model name that Charmed Kubeflow and MLflow are deployed on |
| `resource_dispatcher`|  Map containing the `app_name`, `provides` and `requires` fields of the resource-dispatcher charm |
| `tls_certificate_requirer`|  Map containing the `app_name` and the `requires` TLS endpoint of the TLS requirer charm |
| `ingress_provider`| Map containing the `app_name` and the `provides` endpoint of the ingress provider charm |
| `dashboard_links_provider`| Map containing the `app_name` and the `provides` endpoint of the dashboard links provider charm |
| `kserve_controller`|  Map containing the `app_name`, `provides` and `requires` fields of the kserve-controller charm |

## Usage

This solution module is intended to be used either on its own or as part of a higher-level module. 

### Model
By default, this solution creates a model of the name `kubeflow`, but can also be deployed in other models through the `model_name` variable.

### Change the default model
To deploy this solution module in a model other than the default `kubeflow` one, pass the targeted model name to the `model_name` variable.
```
terraform apply -var model_name="custom_model_name"
```

### Set public URL
If not explicitly set, var.public_url defaults to `null`, resulting in a local.public_url that includes the model name based on the below expression in `main.tf`.
```
 public_url = var.public_url != null ? var.public_url : "http://dex-auth.${local.model}.svc:5556"
 ```
This will guarantee requests to dex are properly routed to the dex pods running in the correct Kubernetes namespace. The dex-auth url can also be explicitly set by passing the url to the `public_url` variable. This will take precedence over the url value derived from the `http://dex-auth.${local.model}.svc:5556` expression.
```
terraform apply -var public_url="https://custom-auth.url.com:5556"
```

### COS configuration

#### Enable COS configuration
The `cos_configuration` input enables the solution to configure Charmed Kubeflow and MLflow to integrate with COS. This is done by deploying a `opentelemetry-collector-k8s` charm and adding all the required relations.
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

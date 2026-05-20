# MLflow Component

Terraform module deploying the MLflow model tracking component for Charmed Kubeflow.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| mlflow-server | mlflow-server | MLflow experiment tracking server |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `object_storage` | Object storage provider for mlflow-server from minio:object-storage | no |
| `ingress` | Ingress provider for mlflow-server (istio sidecar) | no |
| `istio_ingress_route` | Istio ingress route for mlflow-server (ambient) | no |
| `service_mesh` | Service mesh provider for mlflow-server (ambient) | no |
| `mlflow_server` | Configuration for mlflow-server | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `components` | Map of deployed MLflow applications |
| `requires` | Endpoints required from other components |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.1.1 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [juju_application.mlflow_server](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.mlflow_server_dashboard_links](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_ingress](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_istio_ingress_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_mysql_database](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_object_storage](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_pod_defaults](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_secrets](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_dashboard_links"></a> [dashboard\_links](#input\_dashboard\_links) | Kubeflow Dashboard links provider for mlflow-server from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress provider for mlflow-server from istio-pilot:ingress (sidecar; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_istio_ingress_route"></a> [istio\_ingress\_route](#input\_istio\_ingress\_route) | Istio ingress route provider for mlflow-server from istio-ingress-k8s:istio-ingress-route (ambient; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_mlflow_server"></a> [mlflow\_server](#input\_mlflow\_server) | Configuration for mlflow-server application | <pre>object({<br/>    app_name    = optional(string, "mlflow-server")<br/>    channel     = optional(string, "2.22/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where MLflow is deployed | `string` | n/a | yes |
| <a name="input_mysql_database"></a> [mysql\_database](#input\_mysql\_database) | MySQL database provider for mlflow-server from mysql-k8s:database (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_object_storage"></a> [object\_storage](#input\_object\_storage) | Object storage provider for mlflow-server from minio:object-storage (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_pod_defaults"></a> [pod\_defaults](#input\_pod\_defaults) | Pod defaults provider for mlflow-server from resource-dispatcher:pod-defaults (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secrets provider for mlflow-server from resource-dispatcher:secrets (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_service_mesh"></a> [service\_mesh](#input\_service\_mesh) | Service mesh provider for mlflow-server from istio-beacon-k8s:service-mesh (ambient; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed MLflow applications |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of endpoints provided by this component to other components (outbound relations) |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->
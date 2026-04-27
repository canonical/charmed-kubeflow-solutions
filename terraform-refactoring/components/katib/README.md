# Katib Component

Terraform module deploying the Katib hyperparameter tuning component for Charmed Kubeflow.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| katib-controller | katib-controller | Katib experiment controller |
| katib-db-manager | katib-db-manager | Katib database manager |
| katib-ui | katib-ui | Katib web UI |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `mysql_database` | MySQL database provider for katib-db-manager | no |
| `dashboard_links` | Kubeflow Dashboard links provider for katib-ui | no |
| `ingress` | Ingress provider for katib-ui (istio sidecar) | no |
| `istio_ingress_route` | Istio ingress route for katib-ui (ambient) | no |
| `service_mesh` | Service mesh provider for all Katib apps (ambient) | no |
| `katib_controller` | Configuration for katib-controller | no |
| `katib_db_manager` | Configuration for katib-db-manager | no |
| `katib_ui` | Configuration for katib-ui | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `components` | Map of deployed Katib applications |
| `provides` | Endpoints provided to other components |
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
| [juju_application.katib_controller](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.katib_db_manager](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.katib_ui](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.katib_controller_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_db_manager_katib_controller_k8s_service_info](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_db_manager_mysql_database](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_ui_dashboard_links](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_ui_ingress](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_ui_istio_ingress_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_ui_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_dashboard_links"></a> [dashboard\_links](#input\_dashboard\_links) | Kubeflow Dashboard links provider for katib-ui from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress provider for katib-ui from istio-pilot:ingress (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_istio_ingress_route"></a> [istio\_ingress\_route](#input\_istio\_ingress\_route) | Istio ingress route provider for katib-ui from istio-ingress-k8s:istio-ingress-route (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_katib_controller"></a> [katib\_controller](#input\_katib\_controller) | Configuration for katib-controller application | <pre>object({<br/>    app_name    = optional(string, "katib-controller")<br/>    channel     = optional(string, "0.19/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_katib_db_manager"></a> [katib\_db\_manager](#input\_katib\_db\_manager) | Configuration for katib-db-manager application | <pre>object({<br/>    app_name    = optional(string, "katib-db-manager")<br/>    channel     = optional(string, "0.19/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_katib_ui"></a> [katib\_ui](#input\_katib\_ui) | Configuration for katib-ui application | <pre>object({<br/>    app_name    = optional(string, "katib-ui")<br/>    channel     = optional(string, "0.19/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where Katib is deployed | `string` | n/a | yes |
| <a name="input_mysql_database"></a> [mysql\_database](#input\_mysql\_database) | MySQL database provider for katib-db-manager from mysql-k8s:database (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_service_mesh"></a> [service\_mesh](#input\_service\_mesh) | Service mesh provider for Katib applications from istio-beacon-k8s:service-mesh (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed Katib applications |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->
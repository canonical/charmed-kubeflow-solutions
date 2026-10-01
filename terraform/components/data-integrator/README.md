# Data Kubeflow Integrator Component

Terraform module deploying the `data-kubeflow-integrator` charm for Charmed Kubeflow. This charm integrates data services (MySQL, PostgreSQL, Spark) with Kubeflow user profiles via the resource-dispatcher.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| data-kubeflow-integrator | data-kubeflow-integrator | Integrates data services with Kubeflow user namespaces |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `profile` | Kubeflow profile name(s) to apply integrations to | no |
| `data_kubeflow_integrator` | Application configuration object (app_name, channel, revision, etc.) | no |
| `mysql` | MySQL integration endpoint or offer | no |
| `postgresql` | PostgreSQL integration endpoint or offer | no |
| `spark` | Spark integration endpoint or offer | no |
| `resource_dispatcher_endpoints` | Map of resource-dispatcher endpoints to integrate with | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `application` | The deployed juju_application object |
| `app_name` | Name of the deployed application |
| `requires` | Required endpoints: `secrets`, `pod_defaults`, `service_accounts`, `roles`, `role_bindings` |
| `provides` | Provided endpoints (empty map) |

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

## Resources

| Name | Type |
| ---- | ---- |
| [juju_application.data_integrator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.data_integrator_mlflow_server](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_data_integrator"></a> [data\_integrator](#input\_data\_integrator) | Configuration for data-integrator application | <pre>object({<br/>    app_name    = optional(string, "data-integrator")<br/>    channel     = optional(string, "latest/edge")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, false)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_mlflow_server_endpoint"></a> [mlflow\_server\_endpoint](#input\_mlflow\_server\_endpoint) | n/a | <pre>object({<br/>    name               = string<br/>    endpoint           = string<br/>  })</pre> | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | Reference to an existing model uuid. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | Name of the deployed data-integrator. |
| <a name="output_application"></a> [application](#output\_application) | Object representing the deployed application. |
| <a name="output_provides"></a> [provides](#output\_provides) | Provides endpoints. |
| <a name="output_requires"></a> [requires](#output\_requires) | Requires endpoints. |
<!-- END_TF_DOCS -->

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

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [juju_application.integrator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.mysql](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.postgresql](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.resource_dispatcher_kubeflow_integrator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.spark](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_data_kubeflow_integrator"></a> [data\_kubeflow\_integrator](#input\_data\_kubeflow\_integrator) | Configuration for data-kubeflow-integrator application | `object({...})` | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | Reference to an existing model uuid. | `string` | n/a | yes |
| <a name="input_mysql"></a> [mysql](#input\_mysql) | MySQL integration endpoint or offer | `object({...})` | `null` | no |
| <a name="input_postgresql"></a> [postgresql](#input\_postgresql) | PostgreSQL integration endpoint or offer | `object({...})` | `null` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | Name of profiles to apply this to | `string` | `"*"` | no |
| <a name="input_resource_dispatcher_endpoints"></a> [resource\_dispatcher\_endpoints](#input\_resource\_dispatcher\_endpoints) | Pointers for the resource dispatcher endpoints | `map(object({...}))` | `{}` | no |
| <a name="input_spark"></a> [spark](#input\_spark) | Spark integration endpoint or offer | `object({...})` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | Name of the deployed data-kubeflow integrator. |
| <a name="output_application"></a> [application](#output\_application) | Object representing the deployed application. |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of provided endpoints. |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of required endpoints. |
<!-- END_TF_DOCS -->

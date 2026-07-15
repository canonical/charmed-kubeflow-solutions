# Resource Dispatcher Charm

Terraform module deploying the resource-dispatcher charm for Charmed Kubeflow.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| resource-dispatcher | resource-dispatcher | Dispatches Kubernetes resources (Secrets, PodDefaults) into user namespaces |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `app_name` | Name to give the deployed application | no |
| `channel` | Channel of the charm | no |
| `revision` | Revision number of the charm | no |
| `config` | Map for configuration options | no |
| `units` | Unit count | no |
| `trust` | Whether the application should be trusted | no |
| `constraints` | String listing constraints | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `application` | The deployed juju_application object |
| `app_name` | Name of the deployed application |
| `provides` | Provided endpoints: `secrets`, `pod_defaults` |

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
| [juju_application.resource_dispatcher](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name to give the deployed application. | `string` | `"resource-dispatcher"` | no |
| <a name="input_channel"></a> [channel](#input\_channel) | Channel of the charm. | `string` | `"2.0/stable"` | no |
| <a name="input_config"></a> [config](#input\_config) | Map for configuration options. | `map(string)` | `{}` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | String listing constraints for this application. | `string` | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | Reference to an existing model uuid. | `string` | n/a | yes |
| <a name="input_revision"></a> [revision](#input\_revision) | Revision number of the charm. | `number` | `null` | no |
| <a name="input_trust"></a> [trust](#input\_trust) | Whether the application should be trusted. | `bool` | `true` | no |
| <a name="input_units"></a> [units](#input\_units) | Unit count. | `number` | `1` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | Name of the deployed resource-dispatcher application. |
| <a name="output_application"></a> [application](#output\_application) | Object representing the deployed application. |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of provided endpoints. |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of required endpoints. |
<!-- END_TF_DOCS -->

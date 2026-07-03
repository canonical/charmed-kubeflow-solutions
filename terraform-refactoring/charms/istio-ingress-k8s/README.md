# istio-ingress-k8s

Single-charm module for an ambient Istio ingress gateway (`istio-ingress-k8s`).

Instantiated **twice** in the `kubeflow` product:

- `istio-ingress-k8s-m2m` — machine-to-machine / programmatic access.
- `istio-ingress-k8s-ui` — user-interface access.

Each gateway consumes the `istio-k8s` control plane (in the `istio-system`
model) via the `istio_ingress_config` input (a cross-model offer).

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
| [juju_application.istio_ingress_k8s](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.istio_ingress_config](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name to give the deployed application. | `string` | `"istio-ingress-k8s"` | no |
| <a name="input_base"></a> [base](#input\_base) | The operating system on which to deploy. | `string` | `"ubuntu@24.04"` | no |
| <a name="input_channel"></a> [channel](#input\_channel) | Channel of the charm. | `string` | `"2/stable"` | no |
| <a name="input_config"></a> [config](#input\_config) | Map for configuration options. | `map(string)` | `{}` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | String listing constraints for this application. | `string` | `null` | no |
| <a name="input_istio_ingress_config"></a> [istio\_ingress\_config](#input\_istio\_ingress\_config) | Control-plane ingress-config provider for this gateway, from<br/>istio-k8s:istio-ingress-config (interface istio\_ingress\_config). Supports a<br/>same-model endpoint (kind = "endpoint") or a cross-model offer<br/>(kind = "offer"). When istio-k8s runs in the istio-system model this is the<br/>cross-model offer consumed by the gateway. | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | Reference to an existing model uuid. | `string` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | Map of resources to use for the application. | `map(string)` | `{}` | no |
| <a name="input_revision"></a> [revision](#input\_revision) | Revision number of the charm. | `number` | `null` | no |
| <a name="input_trust"></a> [trust](#input\_trust) | Whether the application should be trusted. | `bool` | `true` | no |
| <a name="input_units"></a> [units](#input\_units) | Unit count. | `number` | `1` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_application"></a> [application](#output\_application) | Object representing the deployed application. |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of provided endpoints. |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of required endpoints. |
<!-- END_TF_DOCS -->

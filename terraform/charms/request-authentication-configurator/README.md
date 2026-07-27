# request-authentication-configurator

Single-charm module for `request-authentication-configurator` (no workload).

Creates `RequestAuthentication.security.istio.io` CRs on the two ingress
gateways to validate JWTs minted by the Identity Platform, sharing one issuer
and claim→header mapping.

- `oauth` (requires) → `hydra` in the `iam` model (cross-model offer, via the
  `oauth` input).
- `request-auth-m2m` (requires) → `istio-ingress-k8s-m2m:istio-request-auth`.
- `request-auth-ui` (requires) → `istio-ingress-k8s-ui:istio-request-auth`.

> `user-id-header-name` config is **required** — set it via `config`.

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
| [juju_application.request_authentication_configurator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.oauth](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name to give the deployed application. | `string` | `"request-authentication-configurator"` | no |
| <a name="input_base"></a> [base](#input\_base) | The operating system on which to deploy. | `string` | `"ubuntu@24.04"` | no |
| <a name="input_channel"></a> [channel](#input\_channel) | Channel of the charm. | `string` | `"latest/stable"` | no |
| <a name="input_config"></a> [config](#input\_config) | Map for configuration options. Note: `user-id-header-name` is required by<br/>the charm (it blocks until set) and must be provided here. | `map(string)` | `{}` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | String listing constraints for this application. | `string` | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | Reference to an existing model uuid. | `string` | n/a | yes |
| <a name="input_oauth"></a> [oauth](#input\_oauth) | OAuth provider, from hydra:oauth (interface oauth). Supports a same-model<br/>endpoint (kind = "endpoint") or a cross-model offer (kind = "offer"). When<br/>Hydra runs in the iam model this is the cross-model offer. | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
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

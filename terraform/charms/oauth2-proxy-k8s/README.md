# oauth2-proxy-k8s

Single-charm module for `oauth2-proxy-k8s`.

Acts as the ext-authz / forward-auth provider in front of the UI ingress
gateway, authenticating users against the Canonical Identity Platform.

- `oauth` (requires) → `hydra` in the `iam` model (cross-model offer, via the
  `oauth` input).
- `forward-auth` (provides) → `istio-ingress-k8s-ui:forward-auth` (in-model,
  wired by the kubeflow product).

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
| [juju_application.oauth2_proxy](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.oauth](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.receive_ca_cert](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name to give the deployed application. | `string` | `"oauth2-proxy"` | no |
| <a name="input_base"></a> [base](#input\_base) | The operating system on which to deploy. | `string` | `"ubuntu@22.04"` | no |
| <a name="input_ca_cert"></a> [ca\_cert](#input\_ca\_cert) | CA certificate provider for oauth2-proxy, consumed on<br/>oauth2-proxy:receive-ca-cert (interface certificate\_transfer). Supports a<br/>same-model endpoint (kind = "endpoint") or a cross-model offer<br/>(kind = "offer"). Used to trust the self-signed CA from the iam-core model<br/>(send-ca-cert offer). | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_channel"></a> [channel](#input\_channel) | Channel of the charm. | `string` | `"latest/stable"` | no |
| <a name="input_config"></a> [config](#input\_config) | Map for configuration options. | `map(string)` | `{}` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | String listing constraints for this application. | `string` | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | Reference to an existing model uuid. | `string` | n/a | yes |
| <a name="input_oauth"></a> [oauth](#input\_oauth) | OAuth provider for oauth2-proxy, from hydra:oauth (interface oauth).<br/>Supports a same-model endpoint (kind = "endpoint") or a cross-model offer<br/>(kind = "offer"). When Hydra runs in the iam model this is the cross-model<br/>offer consumed by oauth2-proxy. | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
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

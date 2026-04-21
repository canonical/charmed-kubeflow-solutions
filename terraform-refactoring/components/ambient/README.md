<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_juju"></a> [juju](#provider\_juju) | 1.4.2 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [juju_application.istio_beacon_k8s](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.istio_ingress_k8s](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.istio_k8s](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.istio_k8s_istio_ingress_k8s_ingress_config](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_istio_beacon_k8s"></a> [istio\_beacon\_k8s](#input\_istio\_beacon\_k8s) | Configuration for istio-beacon-k8s application | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_istio_ingress_k8s"></a> [istio\_ingress\_k8s](#input\_istio\_ingress\_k8s) | Configuration for istio-ingress-k8s application | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_istio_k8s"></a> [istio\_k8s](#input\_istio\_k8s) | Configuration for istio-k8s application | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where Istio Ambient is deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed Istio Ambient applications |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of endpoints provided by this component to other components (outbound relations) |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->
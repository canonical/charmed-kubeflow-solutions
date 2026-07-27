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

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_istio_beacon_k8s"></a> [istio\_beacon\_k8s](#module\_istio\_beacon\_k8s) | git::https://github.com/canonical/istio-beacon-k8s-operator//terraform | 51b204dd50392809692263f6e973d81dd9fe200a |
| <a name="module_istio_ingress_k8s"></a> [istio\_ingress\_k8s](#module\_istio\_ingress\_k8s) | git::https://github.com/canonical/istio-ingress-k8s-operator//terraform | a9ef9646aea149a00a6a7620acaf483249714d04 |
| <a name="module_istio_k8s"></a> [istio\_k8s](#module\_istio\_k8s) | git::https://github.com/canonical/istio-k8s-operator//terraform | e3c216c0fe5a9a42ab8d1b6e16725a97b72bf2a7 |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_integration.istio_k8s_istio_ingress_k8s_ingress_config](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_istio_beacon_k8s"></a> [istio\_beacon\_k8s](#input\_istio\_beacon\_k8s) | Configuration for istio-beacon-k8s application | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_istio_ingress_k8s"></a> [istio\_ingress\_k8s](#input\_istio\_ingress\_k8s) | Configuration for istio-ingress-k8s application | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_istio_k8s"></a> [istio\_k8s](#input\_istio\_k8s) | Configuration for istio-k8s application | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where Istio Ambient is deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed Istio Ambient applications |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of endpoints provided by this component to other components (outbound relations) |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->
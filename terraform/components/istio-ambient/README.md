<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_istio_beacon_k8s"></a> [istio\_beacon\_k8s](#module\_istio\_beacon\_k8s) | git::https://github.com/canonical/service-mesh//charms/istio-beacon-k8s/terraform | 7ee9a3d468dbc85ae6e1492de1ba2b83015e8870 |
| <a name="module_istio_ingress_k8s_ui"></a> [istio\_ingress\_k8s\_ui](#module\_istio\_ingress\_k8s\_ui) | git::https://github.com/canonical/service-mesh//charms/istio-ingress-k8s/terraform | 7ee9a3d468dbc85ae6e1492de1ba2b83015e8870 |
| <a name="module_istio_k8s"></a> [istio\_k8s](#module\_istio\_k8s) | git::https://github.com/canonical/istio-k8s-operator//terraform | 7b1162ba3a9b2af6896545f51e64dd21cc44ee39 |

## Resources

| Name | Type |
|------|------|
| [juju_integration.istio_ingress_k8s_ui_config](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_istio_beacon_k8s"></a> [istio\_beacon\_k8s](#input\_istio\_beacon\_k8s) | Configuration for istio-beacon-k8s application | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_istio_ingress_config"></a> [istio\_ingress\_config](#input\_istio\_ingress\_config) | Optional external istio-k8s:istio-ingress-config provider consumed by the<br/>first ingress gateway. Supports a same-model endpoint (kind = "endpoint")<br/>or a cross-model offer (kind = "offer"). When null, this component deploys<br/>its own istio-k8s control plane and integrates the gateway with it. | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_istio_ingress_k8s"></a> [istio\_ingress\_k8s](#input\_istio\_ingress\_k8s) | Common configuration for each istio-ingress-k8s gateway | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_istio_ingress_k8s_gateways"></a> [istio\_ingress\_k8s\_gateways](#input\_istio\_ingress\_k8s\_gateways) | Ingress gateways to deploy, keyed by gateway role. The UI gateway is required because it consumes istio\_ingress\_config. | <pre>map(object({<br/>    app_name = string<br/>    config   = optional(map(string), {})<br/>  }))</pre> | <pre>{<br/>  m2m = {<br/>    app_name = "istio-ingress-k8s-m2m"<br/>  }<br/>  ui = {<br/>    app_name = "istio-ingress-k8s-ui"<br/>  }<br/>}</pre> | no |
| <a name="input_istio_k8s"></a> [istio\_k8s](#input\_istio\_k8s) | Configuration for the local istio-k8s control plane, deployed when istio\_ingress\_config is null | <pre>object({<br/>    channel     = optional(string, "2/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where Istio Ambient is deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed Istio Ambient applications |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of endpoints provided by this component to other components (outbound relations) |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->

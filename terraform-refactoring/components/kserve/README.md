# KServe Component

Terraform module deploying the KServe model serving component for Charmed Kubeflow.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| kserve-controller | kserve-controller | KServe inference service controller |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `gateway_info` | Gateway info provider for kserve-controller from istio-pilot:gateway-info (sidecar) | no |
| `service_mesh` | Service mesh provider for kserve-controller from istio-beacon-k8s:service-mesh (ambient) | no |
| `kserve_controller` | Configuration for kserve-controller | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `components` | Map of deployed KServe applications |
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
| [juju_application.knative_eventing](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.knative_operator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.knative_serving](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.kserve_controller](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.kserve_controller_gateway_info](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kserve_controller_knative_serving_local_gateway](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kserve_controller_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_gateway_info"></a> [gateway\_info](#input\_gateway\_info) | Gateway info provider for kserve-controller from istio-pilot:gateway-info (sidecar; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_knative_eventing"></a> [knative\_eventing](#input\_knative\_eventing) | Configuration for knative-eventing application | <pre>object({<br/>    app_name    = optional(string, "knative-eventing")<br/>    channel     = optional(string, "1.16/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_knative_operator"></a> [knative\_operator](#input\_knative\_operator) | Configuration for knative-operator application | <pre>object({<br/>    app_name    = optional(string, "knative-operator")<br/>    channel     = optional(string, "1.16/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_knative_serving"></a> [knative\_serving](#input\_knative\_serving) | Configuration for knative-serving application | <pre>object({<br/>    app_name    = optional(string, "knative-serving")<br/>    channel     = optional(string, "1.16/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_kserve_controller"></a> [kserve\_controller](#input\_kserve\_controller) | Configuration for kserve-controller application | <pre>object({<br/>    app_name    = optional(string, "kserve-controller")<br/>    channel     = optional(string, "0.15/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where KServe is deployed | `string` | n/a | yes |
| <a name="input_service_mesh"></a> [service\_mesh](#input\_service\_mesh) | Service mesh provider for kserve-controller from istio-beacon-k8s:service-mesh (ambient; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed KServe applications |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->

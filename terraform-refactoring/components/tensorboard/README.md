# Tensorboard Component

Terraform module deploying the Tensorboard component for Charmed Kubeflow.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| tensorboard-controller | tensorboard-controller | Tensorboard instance controller |
| tensorboards-web-app | tensorboards-web-app | Tensorboards web UI |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `dashboard_links` | Kubeflow Dashboard links provider for tensorboards-web-app | no |
| `ingress` | Ingress provider for tensorboards-web-app (istio sidecar) | no |
| `gateway_info` | Gateway info provider for tensorboard-controller (istio sidecar) | no |
| `gateway_metadata` | Gateway metadata provider for tensorboard-controller (ambient) | no |
| `istio_ingress_route` | Istio ingress route for tensorboards-web-app (ambient) | no |
| `service_mesh` | Service mesh provider for all Tensorboard apps (ambient) | no |
| `tensorboard_controller` | Configuration for tensorboard-controller | no |
| `tensorboards_web_app` | Configuration for tensorboards-web-app | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `components` | Map of deployed Tensorboard applications |
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
| [juju_application.tensorboard_controller](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.tensorboards_web_app](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.tensorboard_controller_gateway_info](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboard_controller_gateway_metadata](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboard_controller_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboards_web_app_dashboard_links](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboards_web_app_ingress](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboards_web_app_istio_ingress_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboards_web_app_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_dashboard_links"></a> [dashboard\_links](#input\_dashboard\_links) | Kubeflow Dashboard links provider for tensorboards-web-app from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_gateway_info"></a> [gateway\_info](#input\_gateway\_info) | Gateway info provider for tensorboard-controller from istio-pilot:gateway-info (sidecar; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_gateway_metadata"></a> [gateway\_metadata](#input\_gateway\_metadata) | Gateway metadata provider for tensorboard-controller from istio-ingress-k8s:gateway-metadata (ambient; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress provider for tensorboards-web-app from istio-pilot:ingress (sidecar; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_istio_ingress_route"></a> [istio\_ingress\_route](#input\_istio\_ingress\_route) | Istio ingress route provider for tensorboards-web-app from istio-ingress-k8s:istio-ingress-route (ambient; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where Tensorboard is deployed | `string` | n/a | yes |
| <a name="input_service_mesh"></a> [service\_mesh](#input\_service\_mesh) | Service mesh provider for Tensorboard applications from istio-beacon-k8s:service-mesh (ambient; supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_tensorboard_controller"></a> [tensorboard\_controller](#input\_tensorboard\_controller) | Configuration for tensorboard-controller application | <pre>object({<br/>    app_name    = optional(string, "tensorboard-controller")<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_tensorboards_web_app"></a> [tensorboards\_web\_app](#input\_tensorboards\_web\_app) | Configuration for tensorboards-web-app application | <pre>object({<br/>    app_name    = optional(string, "tensorboards-web-app")<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed Tensorboard applications |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->

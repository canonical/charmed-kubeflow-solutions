# Notebooks Component

Terraform module deploying the Notebooks component for Charmed Kubeflow.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| notebook-controller | notebook-controller | Notebook CRD controller |
| notebook-web-app | notebook-web-app | Notebook web UI |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `dashboard_links` | Kubeflow Dashboard links provider for notebook-web-app | no |
| `ingress` | Ingress provider for notebook-web-app (istio sidecar) | no |
| `istio_ingress_route` | Istio ingress route for notebook-web-app (ambient) | no |
| `service_mesh` | Service mesh provider for all Notebooks apps (ambient) | no |
| `notebook_controller` | Configuration for notebook-controller | no |
| `notebook_web_app` | Configuration for notebook-web-app | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `components` | Map of deployed Notebooks applications |
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
| [juju_application.jupyter_controller](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.jupyter_ui](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.jupyter-controller_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.jupyter_controller_gateway_metadata](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.jupyter_ui_dashboard_links](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.jupyter_ui_ingress](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.jupyter_ui_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.notebook_web_app_istio_ingress_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_dashboard_links"></a> [dashboard\_links](#input\_dashboard\_links) | Kubeflow Dashboard links provider for jupyter-ui from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_gateway_metadata"></a> [gateway\_metadata](#input\_gateway\_metadata) | Gateway metadata provider for jupyter-controller from istio-ingress-k8s:gateway-metadata (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress provider for notebook-web-app from istio-pilot:ingress (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_istio_ingress_route"></a> [istio\_ingress\_route](#input\_istio\_ingress\_route) | Istio ingress route provider for notebook-web-app from istio-ingress-k8s:istio-ingress-route (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_jupyter_controller"></a> [jupyter\_controller](#input\_jupyter\_controller) | Configuration for jupyter-controller application | <pre>object({<br/>    app_name    = optional(string, "jupyter-controller")<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_jupyter_ui"></a> [jupyter\_ui](#input\_jupyter\_ui) | Configuration for jupyter-ui application | <pre>object({<br/>    app_name    = optional(string, "jupyter-ui")<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where Notebooks is deployed | `string` | n/a | yes |
| <a name="input_service_mesh"></a> [service\_mesh](#input\_service\_mesh) | Service mesh provider for Notebooks applications from istio-beacon-k8s:service-mesh (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed Notebooks applications |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->
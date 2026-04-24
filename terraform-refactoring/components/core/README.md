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
| [juju_application.kubeflow_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.kubeflow_profiles](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.kubeflow_roles](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.kubeflow_volumes](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.metacontroller_operator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.pvcviewer_operator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.kubeflow_dashboard_ingress](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_dashboard_istio_ingress_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_dashboard_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_profiles_dashboard_kubeflow_profiles](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_profiles_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_volumes_ingress](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_volumes_istio_ingress_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_volumes_kubeflow_dashboard_links](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_volumes_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress provider for core applications (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_istio_ingress_route"></a> [istio\_ingress\_route](#input\_istio\_ingress\_route) | Istio ingress route provider for core applications from istio-ingress-k8s:istio-ingress-route (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_kubeflow_dashboard"></a> [kubeflow\_dashboard](#input\_kubeflow\_dashboard) | Configuration for kubeflow-dashboard application | <pre>object({<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_kubeflow_profiles"></a> [kubeflow\_profiles](#input\_kubeflow\_profiles) | Configuration for kubeflow-profiles application | <pre>object({<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_kubeflow_roles"></a> [kubeflow\_roles](#input\_kubeflow\_roles) | Configuration for kubeflow-roles application | <pre>object({<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_kubeflow_volumes"></a> [kubeflow\_volumes](#input\_kubeflow\_volumes) | Configuration for kubeflow-volumes application | <pre>object({<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_metacontroller_operator"></a> [metacontroller\_operator](#input\_metacontroller\_operator) | Configuration for metacontroller-operator application | <pre>object({<br/>    channel     = optional(string, "4.11/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where core components are deployed | `string` | n/a | yes |
| <a name="input_pvcviewer_operator"></a> [pvcviewer\_operator](#input\_pvcviewer\_operator) | Configuration for pvcviewer-operator application | <pre>object({<br/>    channel     = optional(string, "1.10/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string)<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_service_mesh"></a> [service\_mesh](#input\_service\_mesh) | Service mesh provider for core applications from istio-beacon-k8s:service-mesh (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed core component applications |
| <a name="output_offers"></a> [offers](#output\_offers) | Map of cross-component offer URLs |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of endpoints provided by this component to other components (outbound relations) |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->
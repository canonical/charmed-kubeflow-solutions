# Training Component

Terraform module deploying the Training component for Charmed Kubeflow.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| training-operator | training-operator | Kubeflow Training Operator (v1) |
| kubeflow-trainer | kubeflow-trainer | Kubeflow Trainer (v2, optional) |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `enable_v2` | Whether to deploy kubeflow-trainer (v2) | no |
| `dashboard_links` | Kubeflow Dashboard links provider for training apps | no |
| `service_mesh` | Service mesh provider for training apps (ambient) | no |
| `training_operator` | Configuration for training-operator | no |
| `kubeflow_trainer` | Configuration for kubeflow-trainer | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `components` | Map of deployed Training applications |
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
| [juju_application.kubeflow_trainer](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.training_operator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.kubeflow_trainer_dashboard_links](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_trainer_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.training_operator_dashboard_links](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.training_operator_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_dashboard_links"></a> [dashboard\_links](#input\_dashboard\_links) | Kubeflow Dashboard links provider for training apps from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_enable_v1"></a> [enable\_v1](#input\_enable\_v1) | Whether to deploy the training-operator application (v1 training operator) | `bool` | `false` | no |
| <a name="input_enable_v2"></a> [enable\_v2](#input\_enable\_v2) | Whether to deploy the kubeflow-trainer application (v2 training operator) | `bool` | `false` | no |
| <a name="input_kubeflow_trainer"></a> [kubeflow\_trainer](#input\_kubeflow\_trainer) | Configuration for kubeflow-trainer application | <pre>object({<br/>    app_name    = optional(string, "kubeflow-trainer")<br/>    channel     = optional(string, "2.1/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where Training is deployed | `string` | n/a | yes |
| <a name="input_service_mesh"></a> [service\_mesh](#input\_service\_mesh) | Service mesh provider for training apps from istio-beacon-k8s:service-mesh (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_training_operator"></a> [training\_operator](#input\_training\_operator) | Configuration for training-operator application | <pre>object({<br/>    app_name    = optional(string, "training-operator")<br/>    channel     = optional(string, "1.9/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed Training applications |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->
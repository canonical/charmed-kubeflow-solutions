# Resource Dispatcher Charm

Terraform module deploying the resource-dispatcher charm for Charmed Kubeflow.

## Applications

| Name | Charm | Description |
| ---- | ----- | ----------- |
| resource-dispatcher | resource-dispatcher | Dispatches Kubernetes resources (Secrets, PodDefaults) into user namespaces |

## Inputs

| Name | Description | Required |
| ---- | ----------- | :------: |
| `model_uuid` | UUID of the Juju model | yes |
| `app_name` | Name to give the deployed application | no |
| `channel` | Channel of the charm | no |
| `revision` | Revision number of the charm | no |
| `config` | Map for configuration options | no |
| `units` | Unit count | no |
| `trust` | Whether the application should be trusted | no |
| `constraints` | String listing constraints | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `application` | The deployed juju_application object |
| `app_name` | Name of the deployed application |
| `provides` | Provided endpoints: `secrets`, `pod_defaults` |

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
<!-- END_TF_DOCS -->

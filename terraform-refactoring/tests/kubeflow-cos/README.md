# Terraform module for Charmed Kubeflow with COS Lite observability

This product deploys [Charmed Kubeflow](https://charmed-kubeflow.io/) together
with the [COS Lite](https://charmhub.io/topics/canonical-observability-stack)
observability stack. The kubeflow observability component is automatically
enabled and wired to the COS Lite offers (Grafana dashboards, Loki logging, and
Prometheus metrics).

## Models

| Model | Contents |
| ----- | -------- |
| `kubeflow` (default) | All Kubeflow components + opentelemetry-collector-k8s |
| `cos` (default) | Alertmanager, Grafana, Loki, Prometheus, Traefik, Catalogue |

## Basic usage

```hcl
module "kubeflow_cos" {
  source = "git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/products/kubeflow-cos?ref=main"

  risk       = "stable"
  cos_channel = "2/stable"
}
```

Then deploy with:

```bash
terraform init
terraform apply
```

## Inputs

| Name | Description | Default |
| ---- | ----------- | ------- |
| `create_cos_model` | Create a Juju model for COS | `true` |
| `cos_model_uuid` | UUID of an existing Juju model for COS (when `create_cos_model = false`) | `null` |
| `cos_model_name` | Name of the COS Juju model | `"cos"` |
| `cos_channel` | Channel for COS Lite applications | `"2/stable"` |
| `release` | Kubeflow release (`"latest"` or `"1.11"`) | `"latest"` |
| `risk` | Charm risk level (`stable`, `candidate`, `beta`, `edge`) | `"edge"` |
| `create_model` | Create a Juju model named `kubeflow` | `true` |
| `model_uuid` | UUID of an existing Juju model for Kubeflow (when `create_model = false`) | `null` |
| `service_mesh_type` | Service mesh mode: `"sidecar"` or `"ambient"` | `"sidecar"` |
| `istio_k8s_platform` | Platform setting for istio-k8s (ambient mode only) | `""` |
| `mysql` | mysql-k8s configuration object | `{}` |
| `postgresql_k8s` | postgresql-k8s configuration object (Feast) | `{}` |
| `enable_kfp` | Deploy the KFP component | `true` |
| `enable_katib` | Deploy the Katib component | `true` |
| `enable_notebooks` | Deploy the Notebooks component | `true` |
| `enable_tensorboard` | Deploy the Tensorboard component | `true` |
| `enable_training_v1` | Deploy training-operator (v1) | `true` |
| `enable_training_v2` | Deploy kubeflow-trainer (v2) | `false` |
| `enable_mlflow` | Deploy the MLflow component | `false` |
| `enable_kserve` | Deploy the KServe component | `true` |
| `enable_feast` | Deploy the Feast component | `false` |

> **Note:** `enable_observability` is always `true` in this product. The COS
> offer URLs are derived automatically from the deployed COS Lite module.
> Fine-grained per-application revision and config overrides can be set by
> extending this module or by using the `kubeflow` product directly.

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
| <a name="module_cos"></a> [cos](#module\_cos) | git::https://github.com/canonical/observability-stack//terraform/cos-lite | 04ab6c618dbbec62292a052a61cdb402d80e5974 |
| <a name="module_kubeflow"></a> [kubeflow](#module\_kubeflow) | ../../products/kubeflow | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_model.cos](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cos_channel"></a> [cos\_channel](#input\_cos\_channel) | Channel to deploy COS Lite applications from | `string` | `"2/stable"` | no |
| <a name="input_cos_model_name"></a> [cos\_model\_name](#input\_cos\_model\_name) | Name of the Juju model to create for COS | `string` | `"cos"` | no |
| <a name="input_cos_model_uuid"></a> [cos\_model\_uuid](#input\_cos\_model\_uuid) | UUID of an existing Juju model to deploy COS into (required when create\_cos\_model is false) | `string` | `null` | no |
| <a name="input_create_cos_model"></a> [create\_cos\_model](#input\_create\_cos\_model) | Create a Juju model for the COS deployment | `bool` | `true` | no |
| <a name="input_create_model"></a> [create\_model](#input\_create\_model) | Create a Juju model named kubeflow for the Kubeflow deployment | `bool` | `true` | no |
| <a name="input_enable_feast"></a> [enable\_feast](#input\_enable\_feast) | Whether to deploy the Feast component | `bool` | `false` | no |
| <a name="input_enable_katib"></a> [enable\_katib](#input\_enable\_katib) | Whether to deploy the Katib component | `bool` | `true` | no |
| <a name="input_enable_kfp"></a> [enable\_kfp](#input\_enable\_kfp) | Whether to deploy the KFP component | `bool` | `true` | no |
| <a name="input_enable_kserve"></a> [enable\_kserve](#input\_enable\_kserve) | Whether to deploy the KServe component | `bool` | `true` | no |
| <a name="input_enable_mlflow"></a> [enable\_mlflow](#input\_enable\_mlflow) | Whether to deploy the MLflow component | `bool` | `false` | no |
| <a name="input_enable_notebooks"></a> [enable\_notebooks](#input\_enable\_notebooks) | Whether to deploy the Notebooks component | `bool` | `true` | no |
| <a name="input_enable_tensorboard"></a> [enable\_tensorboard](#input\_enable\_tensorboard) | Whether to deploy the Tensorboard component | `bool` | `true` | no |
| <a name="input_enable_training_v1"></a> [enable\_training\_v1](#input\_enable\_training\_v1) | Whether to deploy the training-operator application (v1 training operator) | `bool` | `true` | no |
| <a name="input_enable_training_v2"></a> [enable\_training\_v2](#input\_enable\_training\_v2) | Whether to deploy the kubeflow-trainer application (v2 training operator) | `bool` | `false` | no |
| <a name="input_istio_k8s_platform"></a> [istio\_k8s\_platform](#input\_istio\_k8s\_platform) | Platform configuration for istio-k8s (ambient mode only) | `string` | `""` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of an existing Juju model for Kubeflow (required when create\_model is false) | `string` | `null` | no |
| <a name="input_release"></a> [release](#input\_release) | Kubeflow release to deploy. Use 'latest' for latest tracks or '1.11' for pinned 1.11 tracks. | `string` | `"latest"` | no |
| <a name="input_risk"></a> [risk](#input\_risk) | Value for the risk to be used | `string` | `"edge"` | no |
| <a name="input_service_mesh_type"></a> [service\_mesh\_type](#input\_service\_mesh\_type) | Which service mesh component to deploy: 'sidecar' (Istio sidecar) or 'ambient' (Istio ambient) | `string` | `"sidecar"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
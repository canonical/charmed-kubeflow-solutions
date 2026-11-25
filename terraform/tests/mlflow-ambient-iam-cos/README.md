# mlflow-ambient-iam-cos: MLflow (ambient + IAM) with COS Lite observability

This test module deploys standalone [Charmed MLflow](https://charmhub.io/mlflow-server)
on the Istio ambient mesh with the Canonical Identity Platform (reusing the
[`mlflow-ambient-iam`](../mlflow-ambient-iam) module), together with the
[COS Lite](https://charmhub.io/topics/canonical-observability-stack)
observability stack. The MLflow observability component
(opentelemetry-collector-k8s) is automatically enabled and wired to the COS Lite
offers (Grafana dashboards, Loki logging, and Prometheus metrics).

## Models

| Model | Contents |
| ----- | -------- |
| `mlflow` (default) | MLflow server, PostgreSQL, S3 integrator, ambient gateways + beacon, IAM auth charms, opentelemetry-collector-k8s |
| `istio-system` (default) | istio-k8s (Istio ambient control plane) |
| `iam` (default) | Hydra, Kratos, Identity Platform Login UI |
| `iam-core` | Traefik, PostgreSQL, self-signed-certificates for the Identity Platform |
| `cos` (default) | Alertmanager, Grafana, Loki, Prometheus, Traefik, Catalogue |

## Basic usage

```bash
terraform init
terraform apply \
  -var external_ui_hostname=ui.mlflow.com \
  -var external_m2m_hostname=api.mlflow.com \
  -var external_auth_hostname=auth.mlflow.com
```

> **Note:** `enable_observability` is always `true` in this module. The COS
> offer URLs are derived automatically from the deployed COS Lite module.
> For finer-grained overrides use the [`mlflow-ambient-iam`](../mlflow-ambient-iam)
> module or the [`mlflow`](../../products/mlflow) product directly.

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
| <a name="module_mlflow_ambient_iam"></a> [mlflow\_ambient\_iam](#module\_mlflow\_ambient\_iam) | ../mlflow-ambient-iam | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_model.cos](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cos_channel"></a> [cos\_channel](#input\_cos\_channel) | Channel to deploy COS Lite applications from. | `string` | `"2/stable"` | no |
| <a name="input_cos_model_name"></a> [cos\_model\_name](#input\_cos\_model\_name) | Name of the Juju model to create for COS. | `string` | `"cos"` | no |
| <a name="input_cos_model_uuid"></a> [cos\_model\_uuid](#input\_cos\_model\_uuid) | UUID of an existing Juju model to deploy COS into (required when create\_cos\_model is false). | `string` | `null` | no |
| <a name="input_create_cos_model"></a> [create\_cos\_model](#input\_create\_cos\_model) | Create a Juju model for the COS deployment. | `bool` | `true` | no |
| <a name="input_create_iam_model"></a> [create\_iam\_model](#input\_create\_iam\_model) | Create the iam Juju model for the Identity Platform. | `bool` | `true` | no |
| <a name="input_create_istio_system_model"></a> [create\_istio\_system\_model](#input\_create\_istio\_system\_model) | Create the istio-system Juju model for the Istio control plane (istio-k8s). | `bool` | `true` | no |
| <a name="input_create_model"></a> [create\_model](#input\_create\_model) | Create the mlflow Juju model. | `bool` | `true` | no |
| <a name="input_external_auth_hostname"></a> [external\_auth\_hostname](#input\_external\_auth\_hostname) | External hostname for the iam Traefik ingress. | `string` | n/a | yes |
| <a name="input_external_m2m_hostname"></a> [external\_m2m\_hostname](#input\_external\_m2m\_hostname) | External hostname for the M2M ambient ingress gateway. | `string` | n/a | yes |
| <a name="input_external_ui_hostname"></a> [external\_ui\_hostname](#input\_external\_ui\_hostname) | External hostname for the UI ambient ingress gateway. | `string` | n/a | yes |
| <a name="input_iam_model_name"></a> [iam\_model\_name](#input\_iam\_model\_name) | Name of the iam model to create. | `string` | `"iam"` | no |
| <a name="input_iam_model_uuid"></a> [iam\_model\_uuid](#input\_iam\_model\_uuid) | UUID of an existing model to deploy the Identity Platform into (required when create\_iam\_model is false). | `string` | `null` | no |
| <a name="input_istio_k8s_channel"></a> [istio\_k8s\_channel](#input\_istio\_k8s\_channel) | Channel for the istio-k8s control plane charm. Must be on the 1.31 track (enforced by the pinned upstream module) and match the gateways' istio-ingress-config version. | `string` | `"1.31/stable"` | no |
| <a name="input_istio_k8s_platform"></a> [istio\_k8s\_platform](#input\_istio\_k8s\_platform) | Platform value for istio-k8s (always merged into its config as 'platform', including an empty string). | `string` | `""` | no |
| <a name="input_istio_system_model_name"></a> [istio\_system\_model\_name](#input\_istio\_system\_model\_name) | Name of the istio-system model to create. | `string` | `"istio-system"` | no |
| <a name="input_istio_system_model_uuid"></a> [istio\_system\_model\_uuid](#input\_istio\_system\_model\_uuid) | UUID of an existing model to deploy istio-k8s into (required when create\_istio\_system\_model is false). | `string` | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of an existing mlflow model (required when create\_model is false). | `string` | `null` | no |
| <a name="input_release"></a> [release](#input\_release) | MLflow release to deploy. Use 'latest' for latest tracks or '1.11' for pinned 1.11 tracks. | `string` | `"latest"` | no |
| <a name="input_risk"></a> [risk](#input\_risk) | Charm channel risk level to deploy (stable, candidate, beta, edge). | `string` | `"edge"` | no |
| <a name="input_s3_access_key_global"></a> [s3\_access\_key\_global](#input\_s3\_access\_key\_global) | S3 access key for the shared object storage integration | `string` | `""` | no |
| <a name="input_s3_bucket_global"></a> [s3\_bucket\_global](#input\_s3\_bucket\_global) | S3 bucket for the shared object storage integration | `string` | `""` | no |
| <a name="input_s3_endpoint_global"></a> [s3\_endpoint\_global](#input\_s3\_endpoint\_global) | S3 endpoint for the shared object storage integration | `string` | `""` | no |
| <a name="input_s3_secret_key_global"></a> [s3\_secret\_key\_global](#input\_s3\_secret\_key\_global) | S3 secret key for the shared object storage integration | `string` | `""` | no |
| <a name="input_user_grants_across_workspaces"></a> [user\_grants\_across\_workspaces](#input\_user\_grants\_across\_workspaces) | Grants for all MLflow users across MLflow workspaces in terms of data-integrator instances,<br/>with each item of a list representing grants across all workspaces for a given user, and<br/>with each key representing the instance's name and the corresponding value the respective<br/>instance's relevant configurations for MLflow | <pre>map(object({<br/>    entity_name        = string<br/>    entity_permissions = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cos_model_uuid"></a> [cos\_model\_uuid](#output\_cos\_model\_uuid) | UUID of the cos model hosting COS Lite. |
| <a name="output_iam_model_uuid"></a> [iam\_model\_uuid](#output\_iam\_model\_uuid) | UUID of the iam model hosting the Canonical Identity Platform. |
| <a name="output_istio_ingress_config_offer_url"></a> [istio\_ingress\_config\_offer\_url](#output\_istio\_ingress\_config\_offer\_url) | Cross-model offer URL of istio-k8s:istio-ingress-config consumed by the mlflow gateways. |
| <a name="output_istio_system_model_uuid"></a> [istio\_system\_model\_uuid](#output\_istio\_system\_model\_uuid) | UUID of the istio-system model hosting the Istio control plane. |
| <a name="output_oauth_offer_url"></a> [oauth\_offer\_url](#output\_oauth\_offer\_url) | Cross-model offer URL of hydra:oauth consumed by the mlflow IAM auth charms. |
<!-- END_TF_DOCS -->

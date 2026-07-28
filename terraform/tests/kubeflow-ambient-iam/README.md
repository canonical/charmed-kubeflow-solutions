# kubeflow-ambient-iam deployment

End-to-end deployment that composes Charmed Kubeflow on the **Istio ambient**
service mesh with the **Canonical Identity Platform** (IAM), wiring everything
together across three Juju models in a single Terraform root:

| Model          | Contents                                                                                   |
| -------------- | ------------------------------------------------------------------------------------------ |
| `istio-system` | The Istio control plane (`istio-k8s`). Offers `istio-ingress-config` cross-model.           |
| `iam`          | Hydra / Kratos / Login UI (`products/iam`). Offers Hydra `oauth` cross-model.                |
| `kubeflow`     | Kubeflow apps + the two ambient gateways (`-ui` / `-m2m`) + beacon + the IAM auth charms.   |

## Architecture

```mermaid
flowchart LR
  subgraph istioSystem["model: istio-system"]
    istiok8s[istio-k8s]
  end
  subgraph iam["model: iam"]
    hydra[hydra]
  end
  subgraph kubeflow["model: kubeflow"]
    ingUI[istio-ingress-k8s-ui]
    ingM2M[istio-ingress-k8s-m2m]
    beacon[istio-beacon-k8s]
    o2p[oauth2-proxy]
    rac[request-authentication-configurator]
    apps[Kubeflow applications]
  end

  ingUI == istio_ingress_config offer ==> istiok8s
  o2p == oauth offer ==> hydra
  rac == oauth offer ==> hydra
  o2p -- forward-auth --> ingUI
  rac -- request-auth --> ingUI
  rac -- request-auth --> ingM2M
  apps -. service mesh .- beacon
```

The deployment always uses `service_mesh_type = "ambient"` and `auth_type = "iam"`.
The legacy sidecar + Dex/OIDC path is not used here.

## Cross-model wiring

- `istio-k8s:istio-ingress-config` is offered from `istio-system` and consumed by
  the UI gateway in `kubeflow` (`istio_ingress_config_offer_url`). The M2M gateway
  is JWT-only and is intentionally not wired to it.
- `hydra:oauth` is offered from `iam` and consumed by `oauth2-proxy` and
  `request-authentication-configurator` in `kubeflow` (`oauth_offer_url`).

## Notes

- The `iam` product uses a **vendored, patched** copy of
  `iam-bundle-integration` (see
  `terraform-refactoring/vendor/iam-bundle-integration/`) so the Identity
  Platform can compose in the same Terraform root as the rest of the deployment
  on the Juju provider `1.x`.
- Spark integration is not part of this deployment.

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
| <a name="module_iam"></a> [iam](#module\_iam) | ../../products/iam | n/a |
| <a name="module_istio_k8s"></a> [istio\_k8s](#module\_istio\_k8s) | git::https://github.com/canonical/istio-k8s-operator//terraform | df6c85dea5decdd014fd187404163ef2d73263da |
| <a name="module_kubeflow"></a> [kubeflow](#module\_kubeflow) | ../../products/kubeflow | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_integration.istio_k8s_jwks_ca_cert](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_model.istio_system](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |
| [juju_offer.istio_ingress_config](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_create_iam_model"></a> [create\_iam\_model](#input\_create\_iam\_model) | Create the iam Juju model for the Identity Platform. | `bool` | `true` | no |
| <a name="input_create_istio_system_model"></a> [create\_istio\_system\_model](#input\_create\_istio\_system\_model) | Create the istio-system Juju model for the Istio control plane (istio-k8s). | `bool` | `true` | no |
| <a name="input_create_model"></a> [create\_model](#input\_create\_model) | Create the kubeflow Juju model. | `bool` | `true` | no |
| <a name="input_dashboards_offer"></a> [dashboards\_offer](#input\_dashboards\_offer) | Offer URL for COS Grafana dashboards. | `string` | `null` | no |
| <a name="input_enable_feast"></a> [enable\_feast](#input\_enable\_feast) | Deploy Feast. | `bool` | `false` | no |
| <a name="input_enable_katib"></a> [enable\_katib](#input\_enable\_katib) | Deploy Katib. | `bool` | `true` | no |
| <a name="input_enable_kfp"></a> [enable\_kfp](#input\_enable\_kfp) | Deploy Kubeflow Pipelines. | `bool` | `true` | no |
| <a name="input_enable_kratos_external_idp_integrator"></a> [enable\_kratos\_external\_idp\_integrator](#input\_enable\_kratos\_external\_idp\_integrator) | Deploy the Kratos External IdP Integrator (Google / Entra / etc.). | `bool` | `false` | no |
| <a name="input_enable_kserve"></a> [enable\_kserve](#input\_enable\_kserve) | Deploy KServe. | `bool` | `true` | no |
| <a name="input_enable_mlflow"></a> [enable\_mlflow](#input\_enable\_mlflow) | Deploy MLflow. | `bool` | `false` | no |
| <a name="input_enable_notebooks"></a> [enable\_notebooks](#input\_enable\_notebooks) | Deploy Notebooks. | `bool` | `true` | no |
| <a name="input_enable_observability"></a> [enable\_observability](#input\_enable\_observability) | Enable observability wiring to an external COS deployment. | `bool` | `false` | no |
| <a name="input_enable_tensorboard"></a> [enable\_tensorboard](#input\_enable\_tensorboard) | Deploy Tensorboard. | `bool` | `true` | no |
| <a name="input_enable_training_v1"></a> [enable\_training\_v1](#input\_enable\_training\_v1) | Deploy the v1 Training Operator. | `bool` | `true` | no |
| <a name="input_enable_training_v2"></a> [enable\_training\_v2](#input\_enable\_training\_v2) | Deploy the v2 Kubeflow Trainer. | `bool` | `false` | no |
| <a name="input_external_auth_hostname"></a> [external\_auth\_hostname](#input\_external\_auth\_hostname) | External hostname for the iam Traefik ingress. | `string` | n/a | yes |
| <a name="input_external_m2m_hostname"></a> [external\_m2m\_hostname](#input\_external\_m2m\_hostname) | External hostname for the M2M ambient ingress gateway. | `string` | n/a | yes |
| <a name="input_external_ui_hostname"></a> [external\_ui\_hostname](#input\_external\_ui\_hostname) | External hostname for the UI ambient ingress gateway. | `string` | n/a | yes |
| <a name="input_github_profiles_automator_config"></a> [github\_profiles\_automator\_config](#input\_github\_profiles\_automator\_config) | Configuration for the github-profiles-automator charm (e.g. repository and PMR path). | `map(string)` | `{}` | no |
| <a name="input_hydra_revision"></a> [hydra\_revision](#input\_hydra\_revision) | Revision for the Hydra application. | `number` | `null` | no |
| <a name="input_iam_model_name"></a> [iam\_model\_name](#input\_iam\_model\_name) | Name of the iam model to create. | `string` | `"iam"` | no |
| <a name="input_iam_model_uuid"></a> [iam\_model\_uuid](#input\_iam\_model\_uuid) | UUID of an existing model to deploy the Identity Platform into (required when create\_iam\_model is false). | `string` | `null` | no |
| <a name="input_istio_ingress_k8s_m2m_config"></a> [istio\_ingress\_k8s\_m2m\_config](#input\_istio\_ingress\_k8s\_m2m\_config) | Configuration for the M2M ambient gateway (e.g. external\_hostname). | `map(string)` | `{}` | no |
| <a name="input_istio_ingress_k8s_ui_config"></a> [istio\_ingress\_k8s\_ui\_config](#input\_istio\_ingress\_k8s\_ui\_config) | Configuration for the UI ambient gateway (e.g. external\_hostname). | `map(string)` | `{}` | no |
| <a name="input_istio_k8s_channel"></a> [istio\_k8s\_channel](#input\_istio\_k8s\_channel) | Channel for the istio-k8s control plane charm. Use dev/edge: it exposes jwks-ca-cert and matches the gateways' istio-ingress-config version (2/* predates these). | `string` | `"dev/edge"` | no |
| <a name="input_istio_k8s_config"></a> [istio\_k8s\_config](#input\_istio\_k8s\_config) | Configuration for the istio-k8s control plane charm. | `map(string)` | `{}` | no |
| <a name="input_istio_k8s_platform"></a> [istio\_k8s\_platform](#input\_istio\_k8s\_platform) | Platform value for istio-k8s (always merged into its config as 'platform', including an empty string). | `string` | `""` | no |
| <a name="input_istio_k8s_revision"></a> [istio\_k8s\_revision](#input\_istio\_k8s\_revision) | Revision for the istio-k8s control plane charm. | `number` | `null` | no |
| <a name="input_istio_system_model_name"></a> [istio\_system\_model\_name](#input\_istio\_system\_model\_name) | Name of the istio-system model to create. | `string` | `"istio-system"` | no |
| <a name="input_istio_system_model_uuid"></a> [istio\_system\_model\_uuid](#input\_istio\_system\_model\_uuid) | UUID of an existing model to deploy istio-k8s into (required when create\_istio\_system\_model is false). | `string` | `null` | no |
| <a name="input_kratos_external_idp_integrator"></a> [kratos\_external\_idp\_integrator](#input\_kratos\_external\_idp\_integrator) | Configuration for the Kratos External IdP Integrator (passed through to the iam product). | `any` | `{}` | no |
| <a name="input_kratos_revision"></a> [kratos\_revision](#input\_kratos\_revision) | Revision for the Kratos application. | `number` | `null` | no |
| <a name="input_kserve_controller_config"></a> [kserve\_controller\_config](#input\_kserve\_controller\_config) | Configuration for the kserve-controller application (e.g. domain-name). | `map(string)` | `{}` | no |
| <a name="input_logging_offer"></a> [logging\_offer](#input\_logging\_offer) | Offer URL for COS Loki logging. | `string` | `null` | no |
| <a name="input_login_ui_revision"></a> [login\_ui\_revision](#input\_login\_ui\_revision) | Revision for the Identity Platform Login UI application. | `number` | `null` | no |
| <a name="input_metrics_offer"></a> [metrics\_offer](#input\_metrics\_offer) | Offer URL for COS Prometheus remote-write. | `string` | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of an existing kubeflow model (required when create\_model is false). | `string` | `null` | no |
| <a name="input_release"></a> [release](#input\_release) | Kubeflow release to deploy. Use 'latest' for latest tracks or '1.11' for pinned 1.11 tracks. | `string` | `"latest"` | no |
| <a name="input_risk"></a> [risk](#input\_risk) | Charm channel risk level to deploy (stable, candidate, beta, edge). | `string` | `"edge"` | no |
| <a name="input_traefik_config"></a> [traefik\_config](#input\_traefik\_config) | Configuration for the iam Traefik ingress (e.g. external\_hostname). | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_iam_model_uuid"></a> [iam\_model\_uuid](#output\_iam\_model\_uuid) | UUID of the iam model hosting the Canonical Identity Platform. |
| <a name="output_istio_ingress_config_offer_url"></a> [istio\_ingress\_config\_offer\_url](#output\_istio\_ingress\_config\_offer\_url) | Cross-model offer URL of istio-k8s:istio-ingress-config consumed by the kubeflow gateways. |
| <a name="output_istio_system_model_uuid"></a> [istio\_system\_model\_uuid](#output\_istio\_system\_model\_uuid) | UUID of the istio-system model hosting the Istio control plane. |
| <a name="output_oauth_offer_url"></a> [oauth\_offer\_url](#output\_oauth\_offer\_url) | Cross-model offer URL of hydra:oauth consumed by the kubeflow IAM auth charms. |
<!-- END_TF_DOCS -->

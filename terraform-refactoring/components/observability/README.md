# Observability Component

Terraform module that deploys the [opentelemetry-collector-k8s](https://charmhub.io/opentelemetry-collector-k8s) charm and wires it to all Charmed Kubeflow components and charms that expose COS (Cloud Observability Stack) endpoints.

## Applications

| Application | Charm | Default Channel |
|---|---|---|
| opentelemetry-collector-k8s | opentelemetry-collector-k8s | 2/stable |

## Usage

```hcl
module "observability" {
  source     = "../../components/observability"
  model_uuid = juju_model.kubeflow.uuid

  # Core component
  kubeflow_dashboard_grafana_dashboard      = module.core.provides.kubeflow_dashboard_grafana_dashboard
  kubeflow_dashboard_metrics_endpoint       = module.core.provides.kubeflow_dashboard_metrics_endpoint
  kubeflow_profiles_metrics_endpoint        = module.core.provides.kubeflow_profiles_metrics_endpoint
  metacontroller_operator_grafana_dashboard = module.core.provides.metacontroller_operator_grafana_dashboard
  metacontroller_operator_metrics_endpoint  = module.core.provides.metacontroller_operator_metrics_endpoint
  pvcviewer_operator_grafana_dashboard      = module.core.provides.pvcviewer_operator_grafana_dashboard
  pvcviewer_operator_metrics_endpoint       = module.core.provides.pvcviewer_operator_metrics_endpoint
  admission_webhook_logging                 = module.core.requires.admission_webhook_logging
  kubeflow_dashboard_logging                = module.core.requires.kubeflow_dashboard_logging
  kubeflow_profiles_logging                 = module.core.requires.kubeflow_profiles_logging
  kubeflow_volumes_logging                  = module.core.requires.kubeflow_volumes_logging
  pvcviewer_operator_logging                = module.core.requires.pvcviewer_operator_logging

  # Auth component
  dex_auth_grafana_dashboard = module.auth.provides.dex_auth_grafana_dashboard
  dex_auth_metrics_endpoint  = module.auth.provides.dex_auth_metrics_endpoint
  dex_auth_logging           = module.auth.requires.dex_auth_logging
  oidc_gatekeeper_logging    = module.auth.requires.oidc_gatekeeper_logging

  # KFP component
  argo_controller_grafana_dashboard  = module.kfp.provides.argo_controller_grafana_dashboard
  argo_controller_metrics_endpoint   = module.kfp.provides.argo_controller_metrics_endpoint
  envoy_grafana_dashboard            = module.kfp.provides.envoy_grafana_dashboard
  envoy_metrics_endpoint             = module.kfp.provides.envoy_metrics_endpoint
  kfp_api_grafana_dashboard          = module.kfp.provides.kfp_api_grafana_dashboard
  kfp_api_metrics_endpoint           = module.kfp.provides.kfp_api_metrics_endpoint
  argo_controller_logging            = module.kfp.requires.argo_controller_logging
  envoy_logging                      = module.kfp.requires.envoy_logging
  kfp_api_logging                    = module.kfp.requires.kfp_api_logging
  kfp_metadata_writer_logging        = module.kfp.requires.kfp_metadata_writer_logging
  kfp_persistence_logging            = module.kfp.requires.kfp_persistence_logging
  kfp_profile_controller_logging     = module.kfp.requires.kfp_profile_controller_logging
  kfp_schedwf_logging                = module.kfp.requires.kfp_schedwf_logging
  kfp_ui_logging                     = module.kfp.requires.kfp_ui_logging
  kfp_viewer_logging                 = module.kfp.requires.kfp_viewer_logging
  kfp_viz_logging                    = module.kfp.requires.kfp_viz_logging
  mlmd_logging                       = module.kfp.requires.mlmd_logging

  # Katib component
  katib_controller_grafana_dashboard = module.katib.provides.katib_controller_grafana_dashboard
  katib_controller_metrics_endpoint  = module.katib.provides.katib_controller_metrics_endpoint
  katib_controller_logging           = module.katib.requires.katib_controller_logging
  katib_db_manager_logging           = module.katib.requires.katib_db_manager_logging
  katib_ui_logging                   = module.katib.requires.katib_ui_logging

  # KServe component
  kserve_controller_metrics_endpoint = module.kserve.provides.kserve_controller_metrics_endpoint
  knative_operator_metrics_endpoint  = lookup(module.kserve.provides, "knative_operator_metrics_endpoint", null)
  kserve_controller_logging          = module.kserve.requires.kserve_controller_logging
  knative_operator_logging           = lookup(module.kserve.requires, "knative_operator_logging", null)

  # Notebooks component
  jupyter_controller_grafana_dashboard = module.notebooks.provides.jupyter_controller_grafana_dashboard
  jupyter_controller_metrics_endpoint  = module.notebooks.provides.jupyter_controller_metrics_endpoint
  jupyter_controller_logging           = module.notebooks.requires.jupyter_controller_logging
  jupyter_ui_logging                   = module.notebooks.requires.jupyter_ui_logging

  # Training component
  training_operator_grafana_dashboard = lookup(module.training.provides, "training_operator_grafana_dashboard", null)
  training_operator_metrics_endpoint  = lookup(module.training.provides, "training_operator_metrics_endpoint", null)
  kubeflow_trainer_grafana_dashboard  = lookup(module.training.provides, "kubeflow_trainer_grafana_dashboard", null)
  kubeflow_trainer_metrics_endpoint   = lookup(module.training.provides, "kubeflow_trainer_metrics_endpoint", null)

  # Tensorboard component
  tensorboard_controller_metrics_endpoint = module.tensorboard.provides.tensorboard_controller_metrics_endpoint
  tensorboard_controller_logging          = module.tensorboard.requires.tensorboard_controller_logging
  tensorboards_web_app_logging            = module.tensorboard.requires.tensorboards_web_app_logging

  # Istio Sidecar component
  istio_ingressgateway_metrics_endpoint = module.istio_sidecar.provides.istio_ingressgateway_metrics_endpoint
  istio_pilot_grafana_dashboard         = module.istio_sidecar.provides.istio_pilot_grafana_dashboard
  istio_pilot_metrics_endpoint          = module.istio_sidecar.provides.istio_pilot_metrics_endpoint

  # Minio charm
  minio_grafana_dashboard = module.minio.provides.grafana_dashboard
  minio_metrics_endpoint  = module.minio.provides.metrics_endpoint
}
```

## Input Variables

### Application configuration

| Variable | Description | Default |
|---|---|---|
| `model_uuid` | UUID of the Juju model | required |
| `opentelemetry_collector_k8s` | Charm configuration object | `{}` |

### COS endpoint inputs

All endpoint variables follow the same `object({ name = string, endpoint = string })` type and default to `null` (integration is skipped when null).

#### Grafana dashboard endpoints

| Variable | Source |
|---|---|
| `kubeflow_dashboard_grafana_dashboard` | `module.core.provides` |
| `metacontroller_operator_grafana_dashboard` | `module.core.provides` |
| `pvcviewer_operator_grafana_dashboard` | `module.core.provides` |
| `dex_auth_grafana_dashboard` | `module.auth.provides` |
| `argo_controller_grafana_dashboard` | `module.kfp.provides` |
| `envoy_grafana_dashboard` | `module.kfp.provides` |
| `kfp_api_grafana_dashboard` | `module.kfp.provides` |
| `katib_controller_grafana_dashboard` | `module.katib.provides` |
| `jupyter_controller_grafana_dashboard` | `module.notebooks.provides` |
| `training_operator_grafana_dashboard` | `module.training.provides` (v1) |
| `kubeflow_trainer_grafana_dashboard` | `module.training.provides` (v2) |
| `istio_pilot_grafana_dashboard` | `module.istio_sidecar.provides` |
| `minio_grafana_dashboard` | `module.minio.provides` |

#### Metrics endpoints

| Variable | Source |
|---|---|
| `kubeflow_dashboard_metrics_endpoint` | `module.core.provides` |
| `kubeflow_profiles_metrics_endpoint` | `module.core.provides` |
| `metacontroller_operator_metrics_endpoint` | `module.core.provides` |
| `pvcviewer_operator_metrics_endpoint` | `module.core.provides` |
| `dex_auth_metrics_endpoint` | `module.auth.provides` |
| `argo_controller_metrics_endpoint` | `module.kfp.provides` |
| `envoy_metrics_endpoint` | `module.kfp.provides` |
| `kfp_api_metrics_endpoint` | `module.kfp.provides` |
| `katib_controller_metrics_endpoint` | `module.katib.provides` |
| `kserve_controller_metrics_endpoint` | `module.kserve.provides` |
| `knative_operator_metrics_endpoint` | `module.kserve.provides` (conditional) |
| `jupyter_controller_metrics_endpoint` | `module.notebooks.provides` |
| `training_operator_metrics_endpoint` | `module.training.provides` (v1) |
| `kubeflow_trainer_metrics_endpoint` | `module.training.provides` (v2) |
| `tensorboard_controller_metrics_endpoint` | `module.tensorboard.provides` |
| `istio_ingressgateway_metrics_endpoint` | `module.istio_sidecar.provides` |
| `istio_pilot_metrics_endpoint` | `module.istio_sidecar.provides` |
| `minio_metrics_endpoint` | `module.minio.provides` |

#### Logging endpoints

| Variable | Source |
|---|---|
| `admission_webhook_logging` | `module.core.requires` |
| `kubeflow_dashboard_logging` | `module.core.requires` |
| `kubeflow_profiles_logging` | `module.core.requires` |
| `kubeflow_volumes_logging` | `module.core.requires` |
| `pvcviewer_operator_logging` | `module.core.requires` |
| `dex_auth_logging` | `module.auth.requires` |
| `oidc_gatekeeper_logging` | `module.auth.requires` |
| `argo_controller_logging` | `module.kfp.requires` |
| `envoy_logging` | `module.kfp.requires` |
| `kfp_api_logging` | `module.kfp.requires` |
| `kfp_metadata_writer_logging` | `module.kfp.requires` |
| `kfp_persistence_logging` | `module.kfp.requires` |
| `kfp_profile_controller_logging` | `module.kfp.requires` |
| `kfp_schedwf_logging` | `module.kfp.requires` |
| `kfp_ui_logging` | `module.kfp.requires` |
| `kfp_viewer_logging` | `module.kfp.requires` |
| `kfp_viz_logging` | `module.kfp.requires` |
| `mlmd_logging` | `module.kfp.requires` |
| `katib_controller_logging` | `module.katib.requires` |
| `katib_db_manager_logging` | `module.katib.requires` |
| `katib_ui_logging` | `module.katib.requires` |
| `kserve_controller_logging` | `module.kserve.requires` |
| `knative_operator_logging` | `module.kserve.requires` (conditional) |
| `jupyter_controller_logging` | `module.notebooks.requires` |
| `jupyter_ui_logging` | `module.notebooks.requires` |
| `tensorboard_controller_logging` | `module.tensorboard.requires` |
| `tensorboards_web_app_logging` | `module.tensorboard.requires` |

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
| [juju_application.opentelemetry_collector_k8s](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.admission_webhook_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.argo_controller_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.argo_controller_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.argo_controller_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.dex_auth_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.dex_auth_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.dex_auth_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.envoy_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.envoy_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.envoy_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.istio_ingressgateway_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.istio_pilot_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.istio_pilot_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.jupyter_controller_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.jupyter_controller_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.jupyter_controller_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.jupyter_ui_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_controller_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_controller_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_controller_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_db_manager_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.katib_ui_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_api_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_api_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_api_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_metadata_writer_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_persistence_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_profile_controller_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_schedwf_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_ui_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_viewer_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kfp_viz_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.knative_operator_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.knative_operator_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kserve_controller_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kserve_controller_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_dashboard_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_dashboard_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_dashboard_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_profiles_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_profiles_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_trainer_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_trainer_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kubeflow_volumes_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.metacontroller_operator_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.metacontroller_operator_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.minio_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.minio_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlmd_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.oidc_gatekeeper_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.opentelemetry_collector_k8s_grafana_dashboards](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.opentelemetry_collector_k8s_loki](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.opentelemetry_collector_k8s_prometheus](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.pvcviewer_operator_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.pvcviewer_operator_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.pvcviewer_operator_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboard_controller_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboard_controller_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tensorboards_web_app_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.training_operator_grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.training_operator_metrics_endpoint](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_offer.grafana_dashboards](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |
| [juju_offer.loki_logging](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |
| [juju_offer.prometheus_receive_remote_write](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admission_webhook_logging"></a> [admission\_webhook\_logging](#input\_admission\_webhook\_logging) | Logging endpoint from core admission-webhook application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_argo_controller_grafana_dashboard"></a> [argo\_controller\_grafana\_dashboard](#input\_argo\_controller\_grafana\_dashboard) | Grafana dashboard endpoint from kfp argo-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_argo_controller_logging"></a> [argo\_controller\_logging](#input\_argo\_controller\_logging) | Logging endpoint from kfp argo-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_argo_controller_metrics_endpoint"></a> [argo\_controller\_metrics\_endpoint](#input\_argo\_controller\_metrics\_endpoint) | Metrics endpoint from kfp argo-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_dashboards_offer"></a> [dashboards\_offer](#input\_dashboards\_offer) | URL of the `grafana_dashboard` interface offer from the COS stack. | `string` | n/a | yes |
| <a name="input_dex_auth_grafana_dashboard"></a> [dex\_auth\_grafana\_dashboard](#input\_dex\_auth\_grafana\_dashboard) | Grafana dashboard endpoint from auth dex-auth application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_dex_auth_logging"></a> [dex\_auth\_logging](#input\_dex\_auth\_logging) | Logging endpoint from auth dex-auth application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_dex_auth_metrics_endpoint"></a> [dex\_auth\_metrics\_endpoint](#input\_dex\_auth\_metrics\_endpoint) | Metrics endpoint from auth dex-auth application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_envoy_grafana_dashboard"></a> [envoy\_grafana\_dashboard](#input\_envoy\_grafana\_dashboard) | Grafana dashboard endpoint from kfp envoy application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_envoy_logging"></a> [envoy\_logging](#input\_envoy\_logging) | Logging endpoint from kfp envoy application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_envoy_metrics_endpoint"></a> [envoy\_metrics\_endpoint](#input\_envoy\_metrics\_endpoint) | Metrics endpoint from kfp envoy application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_istio_ingressgateway_metrics_endpoint"></a> [istio\_ingressgateway\_metrics\_endpoint](#input\_istio\_ingressgateway\_metrics\_endpoint) | Metrics endpoint from istio-sidecar istio-ingressgateway application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_istio_pilot_grafana_dashboard"></a> [istio\_pilot\_grafana\_dashboard](#input\_istio\_pilot\_grafana\_dashboard) | Grafana dashboard endpoint from istio-sidecar istio-pilot application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_istio_pilot_metrics_endpoint"></a> [istio\_pilot\_metrics\_endpoint](#input\_istio\_pilot\_metrics\_endpoint) | Metrics endpoint from istio-sidecar istio-pilot application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_jupyter_controller_grafana_dashboard"></a> [jupyter\_controller\_grafana\_dashboard](#input\_jupyter\_controller\_grafana\_dashboard) | Grafana dashboard endpoint from notebooks jupyter-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_jupyter_controller_logging"></a> [jupyter\_controller\_logging](#input\_jupyter\_controller\_logging) | Logging endpoint from notebooks jupyter-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_jupyter_controller_metrics_endpoint"></a> [jupyter\_controller\_metrics\_endpoint](#input\_jupyter\_controller\_metrics\_endpoint) | Metrics endpoint from notebooks jupyter-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_jupyter_ui_logging"></a> [jupyter\_ui\_logging](#input\_jupyter\_ui\_logging) | Logging endpoint from notebooks jupyter-ui application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_katib_controller_grafana_dashboard"></a> [katib\_controller\_grafana\_dashboard](#input\_katib\_controller\_grafana\_dashboard) | Grafana dashboard endpoint from katib katib-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_katib_controller_logging"></a> [katib\_controller\_logging](#input\_katib\_controller\_logging) | Logging endpoint from katib katib-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_katib_controller_metrics_endpoint"></a> [katib\_controller\_metrics\_endpoint](#input\_katib\_controller\_metrics\_endpoint) | Metrics endpoint from katib katib-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_katib_db_manager_logging"></a> [katib\_db\_manager\_logging](#input\_katib\_db\_manager\_logging) | Logging endpoint from katib katib-db-manager application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_katib_ui_logging"></a> [katib\_ui\_logging](#input\_katib\_ui\_logging) | Logging endpoint from katib katib-ui application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_api_grafana_dashboard"></a> [kfp\_api\_grafana\_dashboard](#input\_kfp\_api\_grafana\_dashboard) | Grafana dashboard endpoint from kfp kfp-api application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_api_logging"></a> [kfp\_api\_logging](#input\_kfp\_api\_logging) | Logging endpoint from kfp kfp-api application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_api_metrics_endpoint"></a> [kfp\_api\_metrics\_endpoint](#input\_kfp\_api\_metrics\_endpoint) | Metrics endpoint from kfp kfp-api application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_metadata_writer_logging"></a> [kfp\_metadata\_writer\_logging](#input\_kfp\_metadata\_writer\_logging) | Logging endpoint from kfp kfp-metadata-writer application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_persistence_logging"></a> [kfp\_persistence\_logging](#input\_kfp\_persistence\_logging) | Logging endpoint from kfp kfp-persistence application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_profile_controller_logging"></a> [kfp\_profile\_controller\_logging](#input\_kfp\_profile\_controller\_logging) | Logging endpoint from kfp kfp-profile-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_schedwf_logging"></a> [kfp\_schedwf\_logging](#input\_kfp\_schedwf\_logging) | Logging endpoint from kfp kfp-schedwf application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_ui_logging"></a> [kfp\_ui\_logging](#input\_kfp\_ui\_logging) | Logging endpoint from kfp kfp-ui application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_viewer_logging"></a> [kfp\_viewer\_logging](#input\_kfp\_viewer\_logging) | Logging endpoint from kfp kfp-viewer application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kfp_viz_logging"></a> [kfp\_viz\_logging](#input\_kfp\_viz\_logging) | Logging endpoint from kfp kfp-viz application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_knative_operator_logging"></a> [knative\_operator\_logging](#input\_knative\_operator\_logging) | Logging endpoint from kserve knative-operator application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_knative_operator_metrics_endpoint"></a> [knative\_operator\_metrics\_endpoint](#input\_knative\_operator\_metrics\_endpoint) | Metrics endpoint from kserve knative-operator application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kserve_controller_logging"></a> [kserve\_controller\_logging](#input\_kserve\_controller\_logging) | Logging endpoint from kserve kserve-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kserve_controller_metrics_endpoint"></a> [kserve\_controller\_metrics\_endpoint](#input\_kserve\_controller\_metrics\_endpoint) | Metrics endpoint from kserve kserve-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kubeflow_dashboard_grafana_dashboard"></a> [kubeflow\_dashboard\_grafana\_dashboard](#input\_kubeflow\_dashboard\_grafana\_dashboard) | Grafana dashboard endpoint from core kubeflow-dashboard application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kubeflow_dashboard_logging"></a> [kubeflow\_dashboard\_logging](#input\_kubeflow\_dashboard\_logging) | Logging endpoint from core kubeflow-dashboard application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kubeflow_dashboard_metrics_endpoint"></a> [kubeflow\_dashboard\_metrics\_endpoint](#input\_kubeflow\_dashboard\_metrics\_endpoint) | Metrics endpoint from core kubeflow-dashboard application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kubeflow_profiles_logging"></a> [kubeflow\_profiles\_logging](#input\_kubeflow\_profiles\_logging) | Logging endpoint from core kubeflow-profiles application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kubeflow_profiles_metrics_endpoint"></a> [kubeflow\_profiles\_metrics\_endpoint](#input\_kubeflow\_profiles\_metrics\_endpoint) | Metrics endpoint from core kubeflow-profiles application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kubeflow_trainer_grafana_dashboard"></a> [kubeflow\_trainer\_grafana\_dashboard](#input\_kubeflow\_trainer\_grafana\_dashboard) | Grafana dashboard endpoint from training kubeflow-trainer application (v2) | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kubeflow_trainer_metrics_endpoint"></a> [kubeflow\_trainer\_metrics\_endpoint](#input\_kubeflow\_trainer\_metrics\_endpoint) | Metrics endpoint from training kubeflow-trainer application (v2) | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_kubeflow_volumes_logging"></a> [kubeflow\_volumes\_logging](#input\_kubeflow\_volumes\_logging) | Logging endpoint from core kubeflow-volumes application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_logging_offer"></a> [logging\_offer](#input\_logging\_offer) | URL of the `loki_push_api` interface offer from the COS stack. | `string` | n/a | yes |
| <a name="input_metacontroller_operator_grafana_dashboard"></a> [metacontroller\_operator\_grafana\_dashboard](#input\_metacontroller\_operator\_grafana\_dashboard) | Grafana dashboard endpoint from core metacontroller-operator application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_metacontroller_operator_metrics_endpoint"></a> [metacontroller\_operator\_metrics\_endpoint](#input\_metacontroller\_operator\_metrics\_endpoint) | Metrics endpoint from core metacontroller-operator application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_metrics_offer"></a> [metrics\_offer](#input\_metrics\_offer) | URL of the `prometheus_remote_write` interface offer from the COS stack. | `string` | n/a | yes |
| <a name="input_minio_grafana_dashboard"></a> [minio\_grafana\_dashboard](#input\_minio\_grafana\_dashboard) | Grafana dashboard endpoint from minio charm | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_minio_metrics_endpoint"></a> [minio\_metrics\_endpoint](#input\_minio\_metrics\_endpoint) | Metrics endpoint from minio charm | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_mlflow_server_grafana_dashboard"></a> [mlflow\_server\_grafana\_dashboard](#input\_mlflow\_server\_grafana\_dashboard) | Grafana dashboard endpoint from mlflow mlflow-server application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_mlflow_server_logging"></a> [mlflow\_server\_logging](#input\_mlflow\_server\_logging) | Logging endpoint from mlflow mlflow-server application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_mlflow_server_metrics_endpoint"></a> [mlflow\_server\_metrics\_endpoint](#input\_mlflow\_server\_metrics\_endpoint) | Metrics endpoint from mlflow mlflow-server application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_mlmd_logging"></a> [mlmd\_logging](#input\_mlmd\_logging) | Logging endpoint from kfp mlmd application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where observability components are deployed | `string` | n/a | yes |
| <a name="input_oidc_gatekeeper_logging"></a> [oidc\_gatekeeper\_logging](#input\_oidc\_gatekeeper\_logging) | Logging endpoint from auth oidc-gatekeeper application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_opentelemetry_collector_k8s"></a> [opentelemetry\_collector\_k8s](#input\_opentelemetry\_collector\_k8s) | Configuration for opentelemetry-collector-k8s application | <pre>object({<br/>    channel      = optional(string, "2/stable")<br/>    revision     = optional(number)<br/>    units        = optional(number, 1)<br/>    trust        = optional(bool, true)<br/>    constraints  = optional(string)<br/>    config       = optional(map(string), {})<br/>    resources    = optional(map(string), {})<br/>    storage_size = optional(string, "10G")<br/>  })</pre> | `{}` | no |
| <a name="input_pvcviewer_operator_grafana_dashboard"></a> [pvcviewer\_operator\_grafana\_dashboard](#input\_pvcviewer\_operator\_grafana\_dashboard) | Grafana dashboard endpoint from core pvcviewer-operator application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_pvcviewer_operator_logging"></a> [pvcviewer\_operator\_logging](#input\_pvcviewer\_operator\_logging) | Logging endpoint from core pvcviewer-operator application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_pvcviewer_operator_metrics_endpoint"></a> [pvcviewer\_operator\_metrics\_endpoint](#input\_pvcviewer\_operator\_metrics\_endpoint) | Metrics endpoint from core pvcviewer-operator application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_tensorboard_controller_logging"></a> [tensorboard\_controller\_logging](#input\_tensorboard\_controller\_logging) | Logging endpoint from tensorboard tensorboard-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_tensorboard_controller_metrics_endpoint"></a> [tensorboard\_controller\_metrics\_endpoint](#input\_tensorboard\_controller\_metrics\_endpoint) | Metrics endpoint from tensorboard tensorboard-controller application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_tensorboards_web_app_logging"></a> [tensorboards\_web\_app\_logging](#input\_tensorboards\_web\_app\_logging) | Logging endpoint from tensorboard tensorboards-web-app application | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_training_operator_grafana_dashboard"></a> [training\_operator\_grafana\_dashboard](#input\_training\_operator\_grafana\_dashboard) | Grafana dashboard endpoint from training training-operator application (v1) | `object({ name = string, endpoint = string })` | `null` | no |
| <a name="input_training_operator_metrics_endpoint"></a> [training\_operator\_metrics\_endpoint](#input\_training\_operator\_metrics\_endpoint) | Metrics endpoint from training training-operator application (v1) | `object({ name = string, endpoint = string })` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed observability component applications |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of endpoints provided by this component to other components (outbound relations) |
<!-- END_TF_DOCS -->
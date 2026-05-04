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

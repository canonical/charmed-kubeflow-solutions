# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where observability components are deployed"
  type        = string
  nullable    = false
}

variable "opentelemetry_collector_k8s" {
  description = "Configuration for opentelemetry-collector-k8s application"
  type = object({
    channel      = optional(string, "2/stable")
    revision     = optional(number)
    units        = optional(number, 1)
    trust        = optional(bool, true)
    constraints  = optional(string)
    config       = optional(map(string), {})
    resources    = optional(map(string), {})
    storage_size = optional(string, "10G")
  })
  default = {}
}

variable "service_mesh" {
  description = "Service mesh endpoint from istio-beacon-k8s:service-mesh (ambient only; supports same-model endpoint or cross-model offer)"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "dashboards_offer" {
  description = "URL of the `grafana_dashboard` interface offer from the COS stack."
  type        = string
  nullable    = false
}

variable "logging_offer" {
  description = "URL of the `loki_push_api` interface offer from the COS stack."
  type        = string
  nullable    = false
}

variable "metrics_offer" {
  description = "URL of the `prometheus_remote_write` interface offer from the COS stack."
  type        = string
  nullable    = false
}

# ---------------------------------------------------------------------------
# Grafana dashboard endpoints (provided by components/charms)
# ---------------------------------------------------------------------------

variable "kubeflow_dashboard_grafana_dashboard" {
  description = "Grafana dashboard endpoint from core kubeflow-dashboard application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "metacontroller_operator_grafana_dashboard" {
  description = "Grafana dashboard endpoint from core metacontroller-operator application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "pvcviewer_operator_grafana_dashboard" {
  description = "Grafana dashboard endpoint from core pvcviewer-operator application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "dex_auth_grafana_dashboard" {
  description = "Grafana dashboard endpoint from auth dex-auth application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "argo_controller_grafana_dashboard" {
  description = "Grafana dashboard endpoint from kfp argo-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "envoy_grafana_dashboard" {
  description = "Grafana dashboard endpoint from kfp envoy application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_api_grafana_dashboard" {
  description = "Grafana dashboard endpoint from kfp kfp-api application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "katib_controller_grafana_dashboard" {
  description = "Grafana dashboard endpoint from katib katib-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "jupyter_controller_grafana_dashboard" {
  description = "Grafana dashboard endpoint from notebooks jupyter-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "training_operator_grafana_dashboard" {
  description = "Grafana dashboard endpoint from training training-operator application (v1)"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kubeflow_trainer_grafana_dashboard" {
  description = "Grafana dashboard endpoint from training kubeflow-trainer application (v2)"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "istio_pilot_grafana_dashboard" {
  description = "Grafana dashboard endpoint from istio-sidecar istio-pilot application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "minio_grafana_dashboard" {
  description = "Grafana dashboard endpoint from minio charm"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

# ---------------------------------------------------------------------------
# Metrics endpoints (provided by components/charms)
# ---------------------------------------------------------------------------

variable "kubeflow_dashboard_metrics_endpoint" {
  description = "Metrics endpoint from core kubeflow-dashboard application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kubeflow_profiles_metrics_endpoint" {
  description = "Metrics endpoint from core kubeflow-profiles application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "metacontroller_operator_metrics_endpoint" {
  description = "Metrics endpoint from core metacontroller-operator application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "pvcviewer_operator_metrics_endpoint" {
  description = "Metrics endpoint from core pvcviewer-operator application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "dex_auth_metrics_endpoint" {
  description = "Metrics endpoint from auth dex-auth application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "argo_controller_metrics_endpoint" {
  description = "Metrics endpoint from kfp argo-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "envoy_metrics_endpoint" {
  description = "Metrics endpoint from kfp envoy application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_api_metrics_endpoint" {
  description = "Metrics endpoint from kfp kfp-api application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "katib_controller_metrics_endpoint" {
  description = "Metrics endpoint from katib katib-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kserve_controller_metrics_endpoint" {
  description = "Metrics endpoint from kserve kserve-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "knative_operator_metrics_endpoint" {
  description = "Metrics endpoint from kserve knative-operator application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "jupyter_controller_metrics_endpoint" {
  description = "Metrics endpoint from notebooks jupyter-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "training_operator_metrics_endpoint" {
  description = "Metrics endpoint from training training-operator application (v1)"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kubeflow_trainer_metrics_endpoint" {
  description = "Metrics endpoint from training kubeflow-trainer application (v2)"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "tensorboard_controller_metrics_endpoint" {
  description = "Metrics endpoint from tensorboard tensorboard-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "istio_ingressgateway_metrics_endpoint" {
  description = "Metrics endpoint from istio-sidecar istio-ingressgateway application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "istio_pilot_metrics_endpoint" {
  description = "Metrics endpoint from istio-sidecar istio-pilot application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "minio_metrics_endpoint" {
  description = "Metrics endpoint from minio charm"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

# ---------------------------------------------------------------------------
# Logging endpoints (required by charms — collector acts as Loki log sink)
# ---------------------------------------------------------------------------

variable "admission_webhook_logging" {
  description = "Logging endpoint from core admission-webhook application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kubeflow_dashboard_logging" {
  description = "Logging endpoint from core kubeflow-dashboard application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kubeflow_profiles_logging" {
  description = "Logging endpoint from core kubeflow-profiles application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kubeflow_volumes_logging" {
  description = "Logging endpoint from core kubeflow-volumes application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "pvcviewer_operator_logging" {
  description = "Logging endpoint from core pvcviewer-operator application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "dex_auth_logging" {
  description = "Logging endpoint from auth dex-auth application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "oidc_gatekeeper_logging" {
  description = "Logging endpoint from auth oidc-gatekeeper application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "argo_controller_logging" {
  description = "Logging endpoint from kfp argo-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "envoy_logging" {
  description = "Logging endpoint from kfp envoy application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_api_logging" {
  description = "Logging endpoint from kfp kfp-api application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_metadata_writer_logging" {
  description = "Logging endpoint from kfp kfp-metadata-writer application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_persistence_logging" {
  description = "Logging endpoint from kfp kfp-persistence application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_profile_controller_logging" {
  description = "Logging endpoint from kfp kfp-profile-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_schedwf_logging" {
  description = "Logging endpoint from kfp kfp-schedwf application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_ui_logging" {
  description = "Logging endpoint from kfp kfp-ui application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_viewer_logging" {
  description = "Logging endpoint from kfp kfp-viewer application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kfp_viz_logging" {
  description = "Logging endpoint from kfp kfp-viz application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "mlmd_logging" {
  description = "Logging endpoint from kfp mlmd application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "katib_controller_logging" {
  description = "Logging endpoint from katib katib-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "katib_db_manager_logging" {
  description = "Logging endpoint from katib katib-db-manager application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "katib_ui_logging" {
  description = "Logging endpoint from katib katib-ui application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "kserve_controller_logging" {
  description = "Logging endpoint from kserve kserve-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "knative_operator_logging" {
  description = "Logging endpoint from kserve knative-operator application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "jupyter_controller_logging" {
  description = "Logging endpoint from notebooks jupyter-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "jupyter_ui_logging" {
  description = "Logging endpoint from notebooks jupyter-ui application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "tensorboard_controller_logging" {
  description = "Logging endpoint from tensorboard tensorboard-controller application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "tensorboards_web_app_logging" {
  description = "Logging endpoint from tensorboard tensorboards-web-app application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

# ---------------------------------------------------------------------------
# MLflow component
# ---------------------------------------------------------------------------

variable "mlflow_server_grafana_dashboard" {
  description = "Grafana dashboard endpoint from mlflow mlflow-server application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "mlflow_server_metrics_endpoint" {
  description = "Metrics endpoint from mlflow mlflow-server application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

variable "mlflow_server_logging" {
  description = "Logging endpoint from mlflow mlflow-server application"
  type        = object({ name = string, endpoint = string })
  nullable    = true
  default     = null
}

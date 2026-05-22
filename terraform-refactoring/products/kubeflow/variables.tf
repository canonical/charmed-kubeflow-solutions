# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Juju Settings

variable "release" {
  type        = string
  description = "Kubeflow release to deploy. Use 'latest' for latest tracks or '1.11' for pinned 1.11 tracks."
  default     = "latest"

  validation {
    condition     = contains(["1.11", "latest"], var.release)
    error_message = "Valid values for var: release are (1.11 and latest)."
  }
}

variable "risk" {
  type        = string
  description = "Value for the risk to be used"
  default     = "edge"

  validation {
    condition     = contains(["stable", "candidate", "beta", "edge"], var.risk)
    error_message = "Valid values for var: risk are (stable, candidate, beta and edge)."
  }
}

variable "create_model" {
  description = "Create a Juju model named kubeflow for this product deployment"
  type        = bool
  default     = true
}

variable "model_uuid" {
  description = "UUID of an existing Juju model (required when create_model is false)"
  type        = string
  default     = null

  validation {
    condition     = var.create_model || var.model_uuid != null
    error_message = "model_uuid must be provided when create_model is false."
  }
}

# Auth Component Applications

variable "dex_auth_revision" {
  description = "Revision of the dex-auth application"
  type        = number
  default     = null
}

variable "dex_auth_config" {
  description = "Configuration for dex-auth application"
  type        = map(string)
  default     = {}
}

variable "oidc_gatekeeper_revision" {
  description = "Revision of the oidc-gatekeeper application"
  type        = number
  default     = null
}

variable "oidc_gatekeeper_config" {
  description = "Configuration for oidc-gatekeeper application"
  type        = map(string)
  default     = {}
}

# Core Component Applications

variable "admission_webhook_revision" {
  description = "Revision of the admission-webhook application"
  type        = number
  default     = null
}

variable "admission_webhook_config" {
  description = "Configuration for admission-webhook application"
  type        = map(string)
  default     = {}
}

variable "kubeflow_dashboard_revision" {
  description = "Revision of the kubeflow-dashboard application"
  type        = number
  default     = null
}

variable "kubeflow_dashboard_config" {
  description = "Configuration for kubeflow-dashboard application"
  type        = map(string)
  default     = {}
}

variable "kubeflow_profiles_revision" {
  description = "Revision of the kubeflow-profiles application"
  type        = number
  default     = null
}

variable "kubeflow_profiles_config" {
  description = "Configuration for kubeflow-profiles application"
  type        = map(string)
  default     = {}
}

variable "kubeflow_roles_revision" {
  description = "Revision of the kubeflow-roles application"
  type        = number
  default     = null
}

variable "kubeflow_roles_config" {
  description = "Configuration for kubeflow-roles application"
  type        = map(string)
  default     = {}
}

variable "kubeflow_volumes_revision" {
  description = "Revision of the kubeflow-volumes application"
  type        = number
  default     = null
}

variable "kubeflow_volumes_config" {
  description = "Configuration for kubeflow-volumes application"
  type        = map(string)
  default     = {}
}

variable "minio_revision" {
  description = "Revision of the minio application"
  type        = number
  default     = null
}

variable "minio_config" {
  description = "Configuration for minio application"
  type        = map(string)
  default     = {}
}

variable "metacontroller_operator_revision" {
  description = "Revision of the metacontroller-operator application"
  type        = number
  default     = null
}

variable "metacontroller_operator_config" {
  description = "Configuration for metacontroller-operator application"
  type        = map(string)
  default     = {}
}

variable "pvcviewer_operator_revision" {
  description = "Revision of the pvcviewer-operator application"
  type        = number
  default     = null
}

variable "pvcviewer_operator_config" {
  description = "Configuration for pvcviewer-operator application"
  type        = map(string)
  default     = {}
}

# KFP Component Applications

variable "enable_kfp" {
  description = "Whether to deploy the KFP component"
  type        = bool
  default     = true
}

variable "argo_controller_revision" {
  description = "Revision of the argo-controller application"
  type        = number
  default     = null
}

variable "argo_controller_config" {
  description = "Configuration for argo-controller application"
  type        = map(string)
  default     = {}
}

variable "envoy_revision" {
  description = "Revision of the envoy application"
  type        = number
  default     = null
}

variable "envoy_config" {
  description = "Configuration for envoy application"
  type        = map(string)
  default     = {}
}

variable "mlmd_revision" {
  description = "Revision of the mlmd application"
  type        = number
  default     = null
}

variable "mlmd_config" {
  description = "Configuration for mlmd application"
  type        = map(string)
  default     = {}
}

variable "kfp_api_revision" {
  description = "Revision of the kfp-api application"
  type        = number
  default     = null
}

variable "kfp_api_config" {
  description = "Configuration for kfp-api application"
  type        = map(string)
  default     = {}
}

variable "kfp_metadata_writer_revision" {
  description = "Revision of the kfp-metadata-writer application"
  type        = number
  default     = null
}

variable "kfp_metadata_writer_config" {
  description = "Configuration for kfp-metadata-writer application"
  type        = map(string)
  default     = {}
}

variable "kfp_persistence_revision" {
  description = "Revision of the kfp-persistence application"
  type        = number
  default     = null
}

variable "kfp_persistence_config" {
  description = "Configuration for kfp-persistence application"
  type        = map(string)
  default     = {}
}

variable "kfp_profile_controller_revision" {
  description = "Revision of the kfp-profile-controller application"
  type        = number
  default     = null
}

variable "kfp_profile_controller_config" {
  description = "Configuration for kfp-profile-controller application"
  type        = map(string)
  default     = {}
}

variable "kfp_schedwf_revision" {
  description = "Revision of the kfp-schedwf application"
  type        = number
  default     = null
}

variable "kfp_schedwf_config" {
  description = "Configuration for kfp-schedwf application"
  type        = map(string)
  default     = {}
}

variable "kfp_ui_revision" {
  description = "Revision of the kfp-ui application"
  type        = number
  default     = null
}

variable "kfp_ui_config" {
  description = "Configuration for kfp-ui application"
  type        = map(string)
  default     = {}
}

variable "kfp_viewer_revision" {
  description = "Revision of the kfp-viewer application"
  type        = number
  default     = null
}

variable "kfp_viewer_config" {
  description = "Configuration for kfp-viewer application"
  type        = map(string)
  default     = {}
}

variable "kfp_viz_revision" {
  description = "Revision of the kfp-viz application"
  type        = number
  default     = null
}

variable "kfp_viz_config" {
  description = "Configuration for kfp-viz application"
  type        = map(string)
  default     = {}
}

# Istio Component Applications

variable "service_mesh_type" {
  description = "Which service mesh component to deploy: 'istio' (sidecar) or 'ambient'"
  type        = string
  default     = "sidecar"

  validation {
    condition     = contains(["sidecar", "ambient"], var.service_mesh_type)
    error_message = "Valid values for service_mesh_type are (sidecar, ambient)."
  }
}

variable "istio_pilot_revision" {
  description = "Revision of the istio-pilot application"
  type        = number
  default     = null
}

variable "istio_pilot_config" {
  description = "Configuration for istio-pilot application"
  type        = map(string)
  default     = { default-gateway = "kubeflow-gateway" }
}

variable "istio_ingressgateway_revision" {
  description = "Revision of the istio-ingressgateway application"
  type        = number
  default     = null
}

variable "istio_ingressgateway_config" {
  description = "Configuration for istio-ingressgateway application"
  type        = map(string)
  default     = { kind = "ingress" }
}

# Ambient Component Applications

variable "istio_k8s_revision" {
  description = "Revision of the istio-k8s application"
  type        = number
  default     = null
}

variable "istio_k8s_config" {
  description = "Configuration for istio-k8s application"
  type        = map(string)
  default     = {}
}

variable "istio_k8s_platform" {
  description = "Platform configuration for istio-k8s"
  type        = string
  default     = ""
}

variable "istio_ingress_k8s_revision" {
  description = "Revision of the istio-ingress-k8s application"
  type        = number
  default     = null
}

variable "istio_ingress_k8s_config" {
  description = "Configuration for istio-ingress-k8s application"
  type        = map(string)
  default     = {}
}

variable "istio_beacon_k8s_revision" {
  description = "Revision of the istio-beacon-k8s application"
  type        = number
  default     = null
}

variable "istio_beacon_k8s_config" {
  description = "Configuration for istio-beacon-k8s application"
  type        = map(string)
  default     = {}
}

# MySQL Component Applications

variable "mysql_revision" {
  description = "Revision of the mysql-db application"
  type        = number
  default     = null
}

variable "mysql_config" {
  description = "Configuration for the mysql-db application"
  type        = map(string)
  default     = {}
}

# Katib Component Applications

variable "enable_katib" {
  description = "Whether to deploy the Katib component"
  type        = bool
  default     = true
}

variable "katib_controller_revision" {
  description = "Revision of the katib-controller application"
  type        = number
  default     = null
}

variable "katib_controller_config" {
  description = "Configuration for katib-controller application"
  type        = map(string)
  default     = {}
}

variable "katib_db_manager_revision" {
  description = "Revision of the katib-db-manager application"
  type        = number
  default     = null
}

variable "katib_db_manager_config" {
  description = "Configuration for katib-db-manager application"
  type        = map(string)
  default     = {}
}

variable "katib_ui_revision" {
  description = "Revision of the katib-ui application"
  type        = number
  default     = null
}

variable "katib_ui_config" {
  description = "Configuration for katib-ui application"
  type        = map(string)
  default     = {}
}

# Notebooks Component Applications

variable "enable_notebooks" {
  description = "Whether to deploy the Notebooks component"
  type        = bool
  default     = true
}

variable "jupyter_controller_revision" {
  description = "Revision of the jupyter-controller application"
  type        = number
  default     = null
}

variable "jupyter_controller_config" {
  description = "Configuration for jupyter-controller application"
  type        = map(string)
  default     = {}
}

variable "jupyter_ui_revision" {
  description = "Revision of the jupyter-ui application"
  type        = number
  default     = null
}

variable "jupyter_ui_config" {
  description = "Configuration for jupyter-ui application"
  type        = map(string)
  default     = {}
}

# Tensorboard Component Applications

variable "enable_tensorboard" {
  description = "Whether to deploy the Tensorboard component"
  type        = bool
  default     = true
}

variable "tensorboard_controller_revision" {
  description = "Revision of the tensorboard-controller application"
  type        = number
  default     = null
}

variable "tensorboard_controller_config" {
  description = "Configuration for tensorboard-controller application"
  type        = map(string)
  default     = {}
}

variable "tensorboards_web_app_revision" {
  description = "Revision of the tensorboards-web-app application"
  type        = number
  default     = null
}

variable "tensorboards_web_app_config" {
  description = "Configuration for tensorboards-web-app application"
  type        = map(string)
  default     = {}
}

# MLflow Component

variable "enable_mlflow" {
  description = "Whether to deploy the MLflow component (mlflow-server) and resource-dispatcher"
  type        = bool
  default     = false
}

variable "mlflow_server_revision" {
  description = "Revision of the mlflow-server application"
  type        = number
  default     = null
}

variable "mlflow_server_config" {
  description = "Configuration for mlflow-server application"
  type        = map(string)
  default     = {}
}

# Resource Dispatcher Charm

variable "resource_dispatcher_revision" {
  description = "Revision of the resource-dispatcher application"
  type        = number
  default     = null
}

variable "resource_dispatcher_config" {
  description = "Configuration for resource-dispatcher application"
  type        = map(string)
  default     = {}
}

# KServe Component Applications

variable "enable_kserve" {
  description = "Whether to deploy the KServe component"
  type        = bool
  default     = true
}

variable "kserve_controller_revision" {
  description = "Revision of the kserve-controller application"
  type        = number
  default     = null
}

variable "kserve_controller_config" {
  description = "Configuration for kserve-controller application"
  type        = map(string)
  default     = {}

  validation {
    condition     = !(var.service_mesh_type == "ambient" && try(var.kserve_controller_config["deployment-mode"], null) == "knative")
    error_message = "deployment-mode cannot be set to 'knative' when service_mesh_type is 'ambient'."
  }
}

variable "knative_operator_revision" {
  description = "Revision of the knative-operator application"
  type        = number
  default     = null
}

variable "knative_operator_config" {
  description = "Configuration for knative-operator application"
  type        = map(string)
  default     = {}
}

variable "knative_serving_revision" {
  description = "Revision of the knative-serving application"
  type        = number
  default     = null
}

variable "knative_serving_config" {
  description = "Configuration for knative-serving application"
  type        = map(string)
  default     = {}
}

variable "knative_eventing_revision" {
  description = "Revision of the knative-eventing application"
  type        = number
  default     = null
}

variable "knative_eventing_config" {
  description = "Configuration for knative-eventing application"
  type        = map(string)
  default     = {}
}

# Training Component Applications

variable "enable_training_v1" {
  description = "Whether to deploy the training-operator application (v1 training operator)"
  type        = bool
  default     = true
}

variable "enable_training_v2" {
  description = "Whether to deploy the kubeflow-trainer application (v2 training operator)"
  type        = bool
  default     = false
}

variable "training_operator_revision" {
  description = "Revision of the training-operator application"
  type        = number
  default     = null
}

variable "training_operator_config" {
  description = "Configuration for training-operator application"
  type        = map(string)
  default     = {}
}

variable "kubeflow_trainer_revision" {
  description = "Revision of the kubeflow-trainer application"
  type        = number
  default     = null
}

variable "kubeflow_trainer_config" {
  description = "Configuration for kubeflow-trainer application"
  type        = map(string)
  default     = {}
}

# Observability Component

variable "enable_observability" {
  description = "Whether to deploy the observability component (opentelemetry-collector-k8s)"
  type        = bool
  default     = false
}

variable "dashboards_offer" {
  description = "URL of the grafana_dashboard interface offer from the COS stack (required when enable_observability is true)"
  type        = string
  default     = null
}

variable "logging_offer" {
  description = "URL of the loki_push_api interface offer from the COS stack (required when enable_observability is true)"
  type        = string
  default     = null
}

variable "metrics_offer" {
  description = "URL of the prometheus_remote_write interface offer from the COS stack (required when enable_observability is true)"
  type        = string
  default     = null
}

variable "opentelemetry_collector_k8s_revision" {
  description = "Revision of the opentelemetry-collector-k8s application"
  type        = number
  default     = null
}

variable "opentelemetry_collector_k8s_config" {
  description = "Configuration for the opentelemetry-collector-k8s application"
  type        = map(string)
  default     = {}
}

# Feast Component Applications

variable "enable_feast" {
  description = "Whether to deploy the Feast component (feast-integrator and feast-ui)"
  type        = bool
  default     = false
}

variable "feast_integrator_revision" {
  description = "Revision of the feast-integrator application"
  type        = number
  default     = null
}

variable "feast_integrator_config" {
  description = "Configuration for feast-integrator application"
  type        = map(string)
  default     = {}
}

variable "feast_ui_revision" {
  description = "Revision of the feast-ui application"
  type        = number
  default     = null
}

variable "feast_ui_config" {
  description = "Configuration for feast-ui application"
  type        = map(string)
  default     = {}
}

# PostgreSQL for Feast

variable "postgresql_k8s_revision" {
  description = "Revision of the postgresql-k8s application"
  type        = number
  default     = null
}

variable "postgresql_k8s_config" {
  description = "Configuration for the postgresql-k8s application"
  type        = map(string)
  default     = {}
}

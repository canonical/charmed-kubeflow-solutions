variable "cos_configuration" {
  description = "Boolean value that enables COS configuration"
  type        = bool
  default     = false
}

variable "create_model" {
  description = "Allows to skip Juju model creation and re-use a model created in a higher level module"
  type        = bool
  default     = true
}

variable "dex_connectors" {
  description = "dex-auth connectors in yaml format"
  type        = string
  default     = ""
}

variable "existing_grafana_agent_name" {
  description = "Name of an existing grafana-agent-k8s deployment"
  type        = string
  default     = null
}

variable "grafana_agent_k8s_size" {
  description = "Grafana agent database storage size"
  type        = string
  default     = "10G"
}

variable "http_proxy" {
  description = "Value of the http_proxy environment variable"
  type        = string
  default     = ""
}

variable "https_proxy" {
  description = "Value of the https_proxy environment variable"
  type        = string
  default     = ""
}

variable "istio_tls_secret_id" {
  description = "The juju secret id for the tls key/cert for istio-pilot"
  type        = string
  default     = ""
}

variable "jupyter_ui_config" {
  description = "Map of config values passed to jupyter-ui"
  type        = map(string)
  default     = {}
}

variable "katib_db_size" {
  description = "Katib database storage size"
  type        = string
  default     = "10G"
}

variable "kfp_db_size" {
  description = "KFP database storage size"
  type        = string
  default     = "10G"
}

variable "minio_size" {
  description = "MinIO database storage size"
  type        = string
  default     = "10G"
}

variable "mlmd_size" {
  description = "MLMD database storage size"
  type        = string
  default     = "10G"
}

variable "no_proxy" {
  description = "Value of the no_proxy environment variable"
  type        = string
  default     = ""
}

variable "public_url" {
  description = "Public URL of Kubeflow for auth/OIDC"
  type        = string
  default     = "http://dex-auth.kubeflow.svc:5556"
}

variable "admission_webhook_revision" {
  description = "Charm revision for admission-webhook"
  type        = number
  default     = null
}
variable "argo_controller_revision" {
  description = "Charm revision for argo-controller"
  type        = number
  default     = null
}
variable "dex_auth_revision" {
  description = "Charm revision for dex-auth"
  type        = number
  default     = null
}
variable "envoy_revision" {
  description = "Charm revision for envoy"
  type        = number
  default     = null
}
variable "istio_ingressgateway_revision" {
  description = "Charm revision for istio-ingressgateway"
  type        = number
  default     = null
}
variable "istio_pilot_revision" {
  description = "Charm revision for istio-pilot"
  type        = number
  default     = null
}
variable "jupyter_controller_revision" {
  description = "Charm revision for jupyter-controller"
  type        = number
  default     = null
}
variable "jupyter_ui_revision" {
  description = "Charm revision for jupyter-ui"
  type        = number
  default     = null
}
variable "katib_controller_revision" {
  description = "Charm revision for katib-controller"
  type        = number
  default     = null
}
variable "katib_db_revision" {
  description = "Charm revision for katib-db"
  type        = number
  default     = null
}
variable "katib_db_manager_revision" {
  description = "Charm revision for katib-db-manager"
  type        = number
  default     = null
}
variable "katib_ui_revision" {
  description = "Charm revision for katib-ui"
  type        = number
  default     = null
}
variable "kfp_api_revision" {
  description = "Charm revision for kfp-api"
  type        = number
  default     = null
}

variable "kfp_db_revision" {
  description = "Charm revision for kfp-db"
  type        = number
  default     = null
}

variable "kfp_metadata_writer_revision" {
  description = "Charm revision for kfp-metadata-writer"
  type        = number
  default     = null
}

variable "kfp_persistence_revision" {
  description = "Charm revision for kfp-persistence"
  type        = number
  default     = null
}

variable "kfp_profile_controller_revision" {
  description = "Charm revision for kfp-profile-controller"
  type        = number
  default     = null
}

variable "kfp_schedwf_revision" {
  description = "Charm revision for kfp-schedwf"
  type        = number
  default     = null
}

variable "kfp_ui_revision" {
  description = "Charm revision for kfp-ui"
  type        = number
  default     = null
}

variable "kfp_viewer_revision" {
  description = "Charm revision for kfp-viewer"
  type        = number
  default     = null
}

variable "kfp_viz_revision" {
  description = "Charm revision for kfp-viz"
  type        = number
  default     = null
}

variable "knative_eventing_revision" {
  description = "Charm revision for knative-eventing"
  type        = number
  default     = null
}

variable "knative_operator_revision" {
  description = "Charm revision for knative-operator"
  type        = number
  default     = null
}

variable "knative_serving_revision" {
  description = "Charm revision for knative-serving"
  type        = number
  default     = null
}

variable "kserve_controller_revision" {
  description = "Charm revision for kserve-controller"
  type        = number
  default     = null
}

variable "kubeflow_dashboard_revision" {
  description = "Charm revision for kubeflow-dashboard"
  type        = number
  default     = null
}

variable "kubeflow_profiles_revision" {
  description = "Charm revision for kubeflow-profiles"
  type        = number
  default     = null
}

variable "kubeflow_roles_revision" {
  description = "Charm revision for kubeflow-roles"
  type        = number
  default     = null
}

variable "kubeflow_volumes_revision" {
  description = "Charm revision for kubeflow-volumes"
  type        = number
  default     = null
}

variable "metacontroller_operator_revision" {
  description = "Charm revision for metacontroller-operator"
  type        = number
  default     = null
}

variable "mlmd_revision" {
  description = "Charm revision for mlmd"
  type        = number
  default     = null
}

variable "minio_revision" {
  description = "Charm revision for minio"
  type        = number
  default     = null
}

variable "oidc_gatekeeper_revision" {
  description = "Charm revision for oidc-gatekeeper"
  type        = number
  default     = null
}

variable "pvcviewer_operator_revision" {
  description = "Charm revision for pvcviewer-operator"
  type        = number
  default     = null
}

variable "tensorboard_controller_revision" {
  description = "Charm revision for tensorboard-controller"
  type        = number
  default     = null
}

variable "tensorboards_web_app_revision" {
  description = "Charm revision for tensorboards-web-app"
  type        = number
  default     = null
}

variable "training_operator_revision" {
  description = "Charm revision for training-operator"
  type        = number
  default     = null
}

variable "grafana_agent_k8s_revision" {
  description = "Charm revision for grafana-agent-k8s"
  type        = number
  default     = null
}

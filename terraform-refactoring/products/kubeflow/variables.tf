# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Juju Settings

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

variable "mysql_database" {
  description = "MySQL database provider for kfp-api (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.mysql_database == null || contains(["endpoint", "offer"], var.mysql_database.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.mysql_database == null || var.mysql_database.kind != "endpoint" || (var.mysql_database.name != null && var.mysql_database.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.mysql_database == null || var.mysql_database.kind != "offer" || (var.mysql_database.url != null && var.mysql_database.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
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
  default     = {}
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

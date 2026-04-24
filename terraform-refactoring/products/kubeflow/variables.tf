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

# Istio Component Applications

variable "service_mesh_type" {
  description = "Which service mesh component to deploy: 'istio' (sidecar) or 'ambient'"
  type        = string
  default     = "istio"

  validation {
    condition     = contains(["istio", "ambient"], var.service_mesh_type)
    error_message = "Valid values for service_mesh_type are (istio, ambient)."
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

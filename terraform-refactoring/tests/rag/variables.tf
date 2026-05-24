# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# ---------------------------------------------------------------------------
# COS Settings
# ---------------------------------------------------------------------------

variable "cos_model_name" {
  description = "Name of the Juju model to create for COS"
  type        = string
  default     = "cos"
}

variable "cos_channel" {
  description = "Channel to deploy COS Lite applications from"
  type        = string
  default     = "2/stable"
}

# DB

variable "db_model_name" {
  description = "Name of the Juju model to create for COS"
  type        = string
  default     = "database"
}

# DB

variable "kf_model_name" {
  description = "Name of the Juju model to create for COS"
  type        = string
  default     = "kubeflow"
}

# ---------------------------------------------------------------------------
# Kubeflow Settings
# ---------------------------------------------------------------------------

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
  description = "Create a Juju model named kubeflow for the Kubeflow deployment"
  type        = bool
  default     = true
}

variable "model_uuid" {
  description = "UUID of an existing Juju model for Kubeflow (required when create_model is false)"
  type        = string
  default     = null

  validation {
    condition     = var.create_model || var.model_uuid != null
    error_message = "model_uuid must be provided when create_model is false."
  }
}

variable "service_mesh_type" {
  description = "Which service mesh component to deploy: 'sidecar' (Istio sidecar) or 'ambient' (Istio ambient)"
  type        = string
  default     = "sidecar"

  validation {
    condition     = contains(["sidecar", "ambient"], var.service_mesh_type)
    error_message = "Valid values for service_mesh_type are (sidecar, ambient)."
  }
}

variable "istio_k8s_platform" {
  description = "Platform configuration for istio-k8s (ambient mode only)"
  type        = string
  default     = ""
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

variable "no_proxy" {
  description = "Value of the no_proxy environment variable"
  type        = string
  default     = ""
}
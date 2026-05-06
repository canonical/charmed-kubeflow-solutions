# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# ---------------------------------------------------------------------------
# COS Settings
# ---------------------------------------------------------------------------

variable "create_cos_model" {
  description = "Create a Juju model for the COS deployment"
  type        = bool
  default     = true
}

variable "cos_model_uuid" {
  description = "UUID of an existing Juju model to deploy COS into (required when create_cos_model is false)"
  type        = string
  default     = null

  validation {
    condition     = var.create_cos_model || var.cos_model_uuid != null
    error_message = "cos_model_uuid must be provided when create_cos_model is false."
  }
}

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

# ---------------------------------------------------------------------------
# Component Toggles
# ---------------------------------------------------------------------------

variable "enable_kfp" {
  description = "Whether to deploy the KFP component"
  type        = bool
  default     = true
}

variable "enable_katib" {
  description = "Whether to deploy the Katib component"
  type        = bool
  default     = true
}

variable "enable_notebooks" {
  description = "Whether to deploy the Notebooks component"
  type        = bool
  default     = true
}

variable "enable_tensorboard" {
  description = "Whether to deploy the Tensorboard component"
  type        = bool
  default     = true
}

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

variable "enable_mlflow" {
  description = "Whether to deploy the MLflow component"
  type        = bool
  default     = false
}

variable "enable_kserve" {
  description = "Whether to deploy the KServe component"
  type        = bool
  default     = true
}

variable "enable_feast" {
  description = "Whether to deploy the Feast component"
  type        = bool
  default     = false
}

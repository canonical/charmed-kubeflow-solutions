# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# ---------------------------------------------------------------------------
# COS settings
# ---------------------------------------------------------------------------

variable "create_cos_model" {
  description = "Create a Juju model for the COS deployment."
  type        = bool
  default     = true
}

variable "cos_model_uuid" {
  description = "UUID of an existing Juju model to deploy COS into (required when create_cos_model is false)."
  type        = string
  default     = null

  validation {
    condition     = var.create_cos_model || var.cos_model_uuid != null
    error_message = "cos_model_uuid must be provided when create_cos_model is false."
  }
}

variable "cos_model_name" {
  description = "Name of the Juju model to create for COS."
  type        = string
  default     = "cos"
}

variable "cos_channel" {
  description = "Channel to deploy COS Lite applications from."
  type        = string
  default     = "2/stable"
}

# ---------------------------------------------------------------------------
# istio-system (control plane) settings
# ---------------------------------------------------------------------------

variable "create_istio_system_model" {
  description = "Create the istio-system Juju model for the Istio control plane (istio-k8s)."
  type        = bool
  default     = true
}

variable "istio_system_model_name" {
  description = "Name of the istio-system model to create."
  type        = string
  default     = "istio-system"
  nullable    = false
}

variable "istio_system_model_uuid" {
  description = "UUID of an existing model to deploy istio-k8s into (required when create_istio_system_model is false)."
  type        = string
  default     = null
}

variable "istio_k8s_channel" {
  description = "Channel for the istio-k8s control plane charm. Must be on the 1.31 track (enforced by the pinned upstream module) and match the gateways' istio-ingress-config version."
  type        = string
  default     = "1.31/stable"
  nullable    = false
}

variable "istio_k8s_platform" {
  description = "Platform value for istio-k8s (always merged into its config as 'platform', including an empty string)."
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# External hostnames
# ---------------------------------------------------------------------------

variable "external_ui_hostname" {
  description = "External hostname for the UI ambient ingress gateway."
  type        = string
  nullable    = false
}

variable "external_m2m_hostname" {
  description = "External hostname for the M2M ambient ingress gateway."
  type        = string
  nullable    = false
}

variable "external_auth_hostname" {
  description = "External hostname for the iam Traefik ingress."
  type        = string
  nullable    = false
}

# ---------------------------------------------------------------------------
# iam (Canonical Identity Platform) settings
# ---------------------------------------------------------------------------

variable "create_iam_model" {
  description = "Create the iam Juju model for the Identity Platform."
  type        = bool
  default     = true
}

variable "iam_model_name" {
  description = "Name of the iam model to create."
  type        = string
  default     = "iam"
  nullable    = false
}

variable "iam_model_uuid" {
  description = "UUID of an existing model to deploy the Identity Platform into (required when create_iam_model is false)."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------
# MLflow settings
# ---------------------------------------------------------------------------

variable "create_model" {
  description = "Create the mlflow Juju model."
  type        = bool
  default     = true
}

variable "model_uuid" {
  description = "UUID of an existing mlflow model (required when create_model is false)."
  type        = string
  default     = null
}

variable "release" {
  description = "MLflow release to deploy. Use 'latest' for latest tracks or '1.11' for pinned 1.11 tracks."
  type        = string
  default     = "latest"
}

variable "risk" {
  description = "Charm channel risk level to deploy (stable, candidate, beta, edge)."
  type        = string
  default     = "edge"
}

# Object storage (shared/global S3 integrator) variables

variable "s3_secret_key_global" {
  description = "S3 secret key for the shared object storage integration"
  type        = string
  default     = ""
  sensitive   = true
}

variable "s3_access_key_global" {
  description = "S3 access key for the shared object storage integration"
  type        = string
  default     = ""
  sensitive   = true
}

variable "s3_endpoint_global" {
  description = "S3 endpoint for the shared object storage integration"
  type        = string
  default     = ""
}

variable "s3_bucket_global" {
  description = "S3 bucket for the shared object storage integration"
  type        = string
  default     = ""
}

variable "s3_config_global" {
  description = "Configuration for the shared s3-integrator application"
  type        = map(string)
  default     = {}
}

variable "user_grants_across_workspaces" {
  description = <<-EOT
    Grants for all MLflow users across MLflow workspaces in terms of data-integrator instances,
    with each item of a list representing grants across all workspaces for a given user, and
    with each key representing the instance's name and the corresponding value the respective
    instance's relevant configurations for MLflow
  EOT
  type = map(object({
    entity_name        = string
    entity_permissions = string
  }))
  default = {}
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

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

  validation {
    condition     = var.create_istio_system_model || var.istio_system_model_uuid != null
    error_message = "istio_system_model_uuid must be provided when create_istio_system_model is false."
  }
}

variable "istio_k8s_channel" {
  description = "Channel for the istio-k8s control plane charm. Use dev/edge: it exposes jwks-ca-cert and matches the gateways' istio-ingress-config version (2/* predates these)."
  type        = string
  default     = "dev/edge"
  nullable    = false
}

variable "istio_k8s_revision" {
  description = "Revision for the istio-k8s control plane charm."
  type        = number
  default     = null
}

variable "istio_k8s_config" {
  description = "Configuration for the istio-k8s control plane charm."
  type        = map(string)
  default     = {}
}

variable "istio_k8s_platform" {
  description = "Platform value for istio-k8s (always merged into its config as 'platform', including an empty string)."
  type        = string
  default     = ""
}

variable "istio_ingress_k8s_ui_config" {
  description = "Configuration for the UI ambient gateway (e.g. external_hostname)."
  type        = map(string)
  default     = {}
}

variable "istio_ingress_k8s_m2m_config" {
  description = "Configuration for the M2M ambient gateway (e.g. external_hostname)."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# External hostnames
# ---------------------------------------------------------------------------

variable "external_ui_hostname" {
  description = "External hostname for the UI ambient ingress gateway."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.external_ui_hostname)) > 0
    error_message = "external_ui_hostname must not be empty."
  }
}

variable "external_m2m_hostname" {
  description = "External hostname for the M2M ambient ingress gateway."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.external_m2m_hostname)) > 0
    error_message = "external_m2m_hostname must not be empty."
  }
}

variable "external_auth_hostname" {
  description = "External hostname for the iam Traefik ingress."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.external_auth_hostname)) > 0
    error_message = "external_auth_hostname must not be empty."
  }
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

  validation {
    condition     = var.create_iam_model || var.iam_model_uuid != null
    error_message = "iam_model_uuid must be provided when create_iam_model is false."
  }
}

variable "enable_kratos_external_idp_integrator" {
  description = "Deploy the Kratos External IdP Integrator (Google / Entra / etc.)."
  type        = bool
  default     = false
}

variable "kratos_external_idp_integrator" {
  description = "Configuration for the Kratos External IdP Integrator (passed through to the iam product)."
  type        = any
  default     = {}
}

variable "hydra_revision" {
  description = "Revision for the Hydra application."
  type        = number
  default     = null
}

variable "kratos_revision" {
  description = "Revision for the Kratos application."
  type        = number
  default     = null
}

variable "login_ui_revision" {
  description = "Revision for the Identity Platform Login UI application."
  type        = number
  default     = null
}

variable "traefik_config" {
  description = "Configuration for the iam Traefik ingress (e.g. external_hostname)."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# kubeflow settings
# ---------------------------------------------------------------------------

variable "create_model" {
  description = "Create the kubeflow Juju model."
  type        = bool
  default     = true
}

variable "model_uuid" {
  description = "UUID of an existing kubeflow model (required when create_model is false)."
  type        = string
  default     = null
}

variable "release" {
  description = "Kubeflow release to deploy. Use 'latest' for latest tracks or '1.11' for pinned 1.11 tracks."
  type        = string
  default     = "latest"
}

variable "risk" {
  description = "Charm channel risk level to deploy (stable, candidate, beta, edge)."
  type        = string
  default     = "edge"
}

variable "enable_kfp" {
  description = "Deploy Kubeflow Pipelines."
  type        = bool
  default     = true
}

variable "enable_katib" {
  description = "Deploy Katib."
  type        = bool
  default     = true
}

variable "enable_notebooks" {
  description = "Deploy Notebooks."
  type        = bool
  default     = true
}

variable "enable_tensorboard" {
  description = "Deploy Tensorboard."
  type        = bool
  default     = true
}

variable "enable_training_v1" {
  description = "Deploy the v1 Training Operator."
  type        = bool
  default     = true
}

variable "enable_training_v2" {
  description = "Deploy the v2 Kubeflow Trainer."
  type        = bool
  default     = false
}

variable "enable_mlflow" {
  description = "Deploy MLflow."
  type        = bool
  default     = false
}

variable "enable_kserve" {
  description = "Deploy KServe."
  type        = bool
  default     = true
}

variable "enable_feast" {
  description = "Deploy Feast."
  type        = bool
  default     = false
}

variable "kserve_controller_config" {
  description = "Configuration for the kserve-controller application (e.g. domain-name)."
  type        = map(string)
  default     = {}
}

variable "github_profiles_automator_config" {
  description = "Configuration for the github-profiles-automator charm (e.g. repository and PMR path)."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# Observability (optional; wire to an external COS via offer URLs)
# ---------------------------------------------------------------------------

variable "enable_observability" {
  description = "Enable observability wiring to an external COS deployment."
  type        = bool
  default     = false
}

variable "dashboards_offer" {
  description = "Offer URL for COS Grafana dashboards."
  type        = string
  default     = null
}

variable "logging_offer" {
  description = "Offer URL for COS Loki logging."
  type        = string
  default     = null
}

variable "metrics_offer" {
  description = "Offer URL for COS Prometheus remote-write."
  type        = string
  default     = null
}

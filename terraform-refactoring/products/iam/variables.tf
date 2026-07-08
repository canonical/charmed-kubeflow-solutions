# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "create_model" {
  description = "Whether to create the iam model. Set to false to deploy into an existing model referenced by model_uuid."
  type        = bool
  default     = true
}

variable "model_name" {
  description = "Name of the iam model to create when create_model is true."
  type        = string
  default     = "iam"
  nullable    = false
}

variable "model_uuid" {
  description = "UUID of an existing model to deploy into when create_model is false."
  type        = string
  default     = null
}

variable "iam_core_model_name" {
  description = "Name of the iam-core model (postgresql-k8s / traefik-k8s / self-signed-certificates) to create when create_model is true."
  type        = string
  default     = "iam-core"
  nullable    = false
}

variable "iam_core_model_uuid" {
  description = "UUID of an existing iam-core model when create_model is false."
  type        = string
  default     = null
}

# --- Requirement dependencies (deployed in the iam-core model) -------

variable "postgresql_k8s_channel" {
  description = "Channel for the postgresql-k8s dependency."
  type        = string
  default     = "14/stable"
  nullable    = false
}

variable "postgresql_k8s_revision" {
  description = "Revision for the postgresql-k8s dependency."
  type        = number
  default     = null
}

variable "postgresql_k8s_config" {
  description = "Extra config for the postgresql-k8s dependency."
  type        = map(string)
  default     = {}
}

variable "traefik_channel" {
  description = "Channel for the traefik-k8s dependency."
  type        = string
  default     = "latest/stable"
  nullable    = false
}

variable "traefik_revision" {
  description = "Revision for the traefik-k8s dependency."
  type        = number
  default     = null
}

variable "traefik_config" {
  description = "Config for the traefik-k8s dependency (e.g. external_hostname)."
  type        = map(string)
  default     = {}
}

variable "self_signed_certificates_channel" {
  description = "Channel for the self-signed-certificates dependency."
  type        = string
  default     = "latest/stable"
  nullable    = false
}

variable "self_signed_certificates_revision" {
  description = "Revision for the self-signed-certificates dependency."
  type        = number
  default     = null
}

variable "self_signed_certificates_config" {
  description = "Config for the self-signed-certificates dependency."
  type        = map(string)
  default     = {}
}

variable "storage_size" {
  description = "Storage size for the postgresql-k8s dependency."
  type        = string
  default     = "10GB"
  nullable    = false
}

# --- Identity Platform bundle -----------------------------------------------

variable "enable_kratos_external_idp_integrator" {
  description = "Whether to deploy the Kratos External IdP Integrator (Google / Entra / etc.)."
  type        = bool
  default     = false
}

variable "kratos_external_idp_integrator" {
  description = "Configuration for the Kratos External IdP Integrator application (passed through to the iam-bundle module)."
  type        = any
  default     = {}
}

variable "hydra" {
  description = "Configuration for the Hydra application (passed through to the iam-bundle module)."
  type        = any
  default     = {}
}

variable "hydra_revision" {
  description = "Revision for the Hydra application. Overrides the revision in var.hydra when set."
  type        = number
  default     = null
}

variable "kratos" {
  description = "Configuration for the Kratos application (passed through to the iam-bundle module)."
  type        = any
  default     = {}
}

variable "kratos_revision" {
  description = "Revision for the Kratos application. Overrides the revision in var.kratos when set."
  type        = number
  default     = null
}

variable "login_ui" {
  description = "Configuration for the Identity Platform Login UI application (passed through to the iam-bundle module)."
  type        = any
  default     = {}
}

variable "login_ui_revision" {
  description = "Revision for the Identity Platform Login UI application. Overrides the revision in var.login_ui when set."
  type        = number
  default     = null
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "app_name" {
  description = "Name to give the deployed application."
  type        = string
  default     = "request-authentication-configurator"
  nullable    = false
}

variable "base" {
  description = "The operating system on which to deploy."
  type        = string
  default     = "ubuntu@24.04"
  nullable    = false
}

variable "channel" {
  description = "Channel of the charm."
  type        = string
  default     = "latest/stable"
  nullable    = false
}

variable "config" {
  description = <<-EOT
    Map for configuration options. Note: `user-id-header-name` is required by
    the charm (it blocks until set) and must be provided here.
  EOT
  type        = map(string)
  default     = {}
}

variable "constraints" {
  description = "String listing constraints for this application."
  type        = string
  default     = null
}

variable "model_uuid" {
  description = "Reference to an existing model uuid."
  type        = string
  nullable    = false
}

variable "resources" {
  description = "Map of resources to use for the application."
  type        = map(string)
  default     = {}
}

variable "revision" {
  description = "Revision number of the charm."
  type        = number
  default     = null
}

variable "trust" {
  description = "Whether the application should be trusted."
  type        = bool
  default     = true
}

variable "units" {
  description = "Unit count."
  type        = number
  default     = 1
}

variable "oauth" {
  description = <<-EOT
    OAuth provider, from hydra:oauth (interface oauth). Supports a same-model
    endpoint (kind = "endpoint") or a cross-model offer (kind = "offer"). When
    Hydra runs in the iam model this is the cross-model offer.
  EOT
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  default = null

  validation {
    condition     = var.oauth == null || contains(["endpoint", "offer"], var.oauth.kind)
    error_message = "oauth.kind must be one of: endpoint, offer."
  }
  validation {
    condition     = var.oauth == null || var.oauth.kind != "endpoint" || (var.oauth.name != null && var.oauth.name != "")
    error_message = "oauth.name is required when kind is \"endpoint\"."
  }
  validation {
    condition     = var.oauth == null || var.oauth.kind != "offer" || (var.oauth.url != null && var.oauth.url != "")
    error_message = "oauth.url is required when kind is \"offer\"."
  }
}

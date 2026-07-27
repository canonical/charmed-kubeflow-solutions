# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "app_name" {
  description = "Name to give the deployed application."
  type        = string
  default     = "oauth2-proxy"
  nullable    = false
}

variable "base" {
  description = "The operating system on which to deploy."
  type        = string
  default     = "ubuntu@22.04"
  nullable    = false
}

variable "channel" {
  description = "Channel of the charm."
  type        = string
  default     = "latest/stable"
  nullable    = false
}

variable "config" {
  description = "Map for configuration options."
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
    OAuth provider for oauth2-proxy, from hydra:oauth (interface oauth).
    Supports a same-model endpoint (kind = "endpoint") or a cross-model offer
    (kind = "offer"). When Hydra runs in the iam model this is the cross-model
    offer consumed by oauth2-proxy.
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

variable "ca_cert" {
  description = <<-EOT
    CA certificate provider for oauth2-proxy, consumed on
    oauth2-proxy:receive-ca-cert (interface certificate_transfer). Supports a
    same-model endpoint (kind = "endpoint") or a cross-model offer
    (kind = "offer"). Used to trust the self-signed CA from the iam-core model
    (send-ca-cert offer).
  EOT
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  default = null

  validation {
    condition     = var.ca_cert == null || contains(["endpoint", "offer"], var.ca_cert.kind)
    error_message = "ca_cert.kind must be one of: endpoint, offer."
  }
  validation {
    condition     = var.ca_cert == null || var.ca_cert.kind != "endpoint" || (var.ca_cert.name != null && var.ca_cert.name != "")
    error_message = "ca_cert.name is required when kind is \"endpoint\"."
  }
  validation {
    condition     = var.ca_cert == null || var.ca_cert.kind != "offer" || (var.ca_cert.url != null && var.ca_cert.url != "")
    error_message = "ca_cert.url is required when kind is \"offer\"."
  }
}

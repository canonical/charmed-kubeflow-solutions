# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "app_name" {
  description = "Name to give the deployed application."
  type        = string
  default     = "istio-ingress-k8s"
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
  default     = "2/stable"
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

variable "istio_ingress_config" {
  description = <<-EOT
    Control-plane ingress-config provider for this gateway, from
    istio-k8s:istio-ingress-config (interface istio_ingress_config). Supports a
    same-model endpoint (kind = "endpoint") or a cross-model offer
    (kind = "offer"). When istio-k8s runs in the istio-system model this is the
    cross-model offer consumed by the gateway.
  EOT
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  default = null

  validation {
    condition     = var.istio_ingress_config == null || contains(["endpoint", "offer"], var.istio_ingress_config.kind)
    error_message = "istio_ingress_config.kind must be one of: endpoint, offer."
  }
  validation {
    condition     = var.istio_ingress_config == null || var.istio_ingress_config.kind != "endpoint" || (var.istio_ingress_config.name != null && var.istio_ingress_config.name != "")
    error_message = "istio_ingress_config.name is required when kind is \"endpoint\"."
  }
  validation {
    condition     = var.istio_ingress_config == null || var.istio_ingress_config.kind != "offer" || (var.istio_ingress_config.url != null && var.istio_ingress_config.url != "")
    error_message = "istio_ingress_config.url is required when kind is \"offer\"."
  }
}

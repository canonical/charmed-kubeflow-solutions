# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where Istio Ambient is deployed"
  type        = string
  nullable    = false
}

variable "istio_ingress_config" {
  description = <<-EOT
    Control-plane ingress-config provider consumed by both gateways, from
    istio-k8s:istio-ingress-config (interface istio_ingress_config). Supports a
    same-model endpoint (kind = "endpoint") or a cross-model offer
    (kind = "offer"). When istio-k8s runs in the istio-system model this is the
    cross-model offer.
  EOT
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  default = null
}

variable "istio_ingress_k8s" {
  description = "Common configuration for both istio-ingress-k8s gateways (UI and M2M)"
  type = object({
    channel     = optional(string, "2/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    constraints = optional(string)
    config      = optional(map(string), {})
  })
  default = {}
}

variable "istio_ingress_k8s_ui_config" {
  description = "Extra configuration for the UI gateway (merged over istio_ingress_k8s.config)"
  type        = map(string)
  default     = {}
}

variable "istio_ingress_k8s_m2m_config" {
  description = "Extra configuration for the M2M gateway (merged over istio_ingress_k8s.config)"
  type        = map(string)
  default     = {}
}

variable "istio_beacon_k8s" {
  description = "Configuration for istio-beacon-k8s application"
  type = object({
    channel     = optional(string, "2/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    constraints = optional(string)
    config      = optional(map(string), {})
  })
  default = {}
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where Istio Ambient is deployed"
  type        = string
  nullable    = false
}

variable "istio_k8s" {
  description = "Configuration for the local istio-k8s control plane, deployed when istio_ingress_config is null"
  type = object({
    channel     = optional(string, "2/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    constraints = optional(string)
    config      = optional(map(string), {})
  })
  default = {}
}

variable "istio_ingress_config" {
  description = <<-EOT
    Optional external istio-k8s:istio-ingress-config provider consumed by the
    first ingress gateway. Supports a same-model endpoint (kind = "endpoint")
    or a cross-model offer (kind = "offer"). When null, this component deploys
    its own istio-k8s control plane and integrates the gateway with it.
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
    error_message = "istio_ingress_config.kind must be either \"endpoint\" or \"offer\"."
  }
}

variable "istio_ingress_k8s_gateways" {
  description = "Ingress gateways to deploy, keyed by gateway role. The UI gateway is required because it consumes istio_ingress_config."
  type = map(object({
    app_name = string
    config   = optional(map(string), {})
  }))
  default = {
    ui = {
      app_name = "istio-ingress-k8s-ui"
    }
    m2m = {
      app_name = "istio-ingress-k8s-m2m"
    }
  }

  validation {
    condition = contains(keys(var.istio_ingress_k8s_gateways), "ui") && alltrue([
      for gateway in values(var.istio_ingress_k8s_gateways) : trimspace(gateway.app_name) != ""
    ])
    error_message = "istio_ingress_k8s_gateways must include a UI gateway with a non-empty app_name for every gateway."
  }
}

variable "istio_ingress_k8s" {
  description = "Common configuration for each istio-ingress-k8s gateway"
  type = object({
    channel     = optional(string, "2/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    constraints = optional(string)
    config      = optional(map(string), {})
  })
  default = {}
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

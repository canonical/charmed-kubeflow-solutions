# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where Istio Ambient is deployed"
  type        = string
  nullable    = false
}

variable "istio_k8s" {
  description = "Configuration for istio-k8s application"
  type = object({
    channel     = optional(string, "2/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "istio_ingress_k8s" {
  description = "Configuration for istio-ingress-k8s application"
  type = object({
    channel     = optional(string, "2/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "istio_beacon_k8s" {
  description = "Configuration for istio-beacon-k8s application"
  type = object({
    channel     = optional(string, "2/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

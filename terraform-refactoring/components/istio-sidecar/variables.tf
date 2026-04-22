# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where Istio is deployed"
  type        = string
  nullable    = false
}

variable "istio_pilot" {
  description = "Configuration for istio-pilot application"
  type = object({
    channel     = optional(string, "1.28/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "istio_ingressgateway" {
  description = "Configuration for istio-ingressgateway application"
  type = object({
    channel     = optional(string, "1.28/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

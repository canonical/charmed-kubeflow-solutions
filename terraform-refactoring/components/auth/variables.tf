# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "risk" {
  type        = string
  description = "Value for the risk to be used"
  default     = "edge"

  validation {
    condition     = contains(["stable", "candidate", "beta", "edge"], var.risk)
    error_message = "Valid values for var: risk are (stable, candidate, beta and edge)."
  }
}

variable "model_uuid" {
  description = "UUID of the Juju model where auth components are deployed"
  type        = string
  nullable    = false
}

variable "dex_auth" {
  description = "Configuration for dex-auth application"
  type = object({
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "oidc_gatekeeper" {
  description = "Configuration for oidc-gatekeeper application"
  type = object({
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "ingress" {
  description = "Ingress provider for auth applications (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.ingress == null || contains(["endpoint", "offer"], var.ingress.kind)
    error_message = "Valid values for ingress.kind are (endpoint, offer)."
  }
}

variable "ingress_auth" {
  description = "Ingress-auth provider for oidc-gatekeeper from istio-pilot:ingress-auth (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.ingress_auth == null || contains(["endpoint", "offer"], var.ingress_auth.kind)
    error_message = "Valid values for ingress_auth.kind are (endpoint, offer)."
  }
}

variable "service_mesh" {
  description = "Service mesh provider for auth applications from istio-beacon-k8s:service-mesh (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.service_mesh == null || contains(["endpoint", "offer"], var.service_mesh.kind)
    error_message = "Valid values for service_mesh.kind are (endpoint, offer)."
  }
}

variable "istio_ingress_route_unauthenticated" {
  description = "Unauthenticated istio ingress route provider for auth applications from istio-ingress-k8s:istio-ingress-route-unauthenticated (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.istio_ingress_route_unauthenticated == null || contains(["endpoint", "offer"], var.istio_ingress_route_unauthenticated.kind)
    error_message = "Valid values for istio_ingress_route_unauthenticated.kind are (endpoint, offer)."
  }
}

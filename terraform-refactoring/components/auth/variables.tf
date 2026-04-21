# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where auth components are deployed"
  type        = string
  nullable    = false
}

variable "dex_auth" {
  description = "Configuration for dex-auth application"
  type = object({
    channel     = optional(string, "latest/edge")
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
    channel     = optional(string, "latest/edge")
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
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.ingress == null || var.ingress.kind != "endpoint" || (var.ingress.kind != null && var.ingress.kind != "" && var.ingress.name != null && var.ingress.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.ingress == null || var.ingress.kind != "offer" || (var.ingress.url != null && var.ingress.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
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
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.ingress_auth == null || var.ingress_auth.kind != "endpoint" || (var.ingress_auth.kind != null && var.ingress_auth.kind != "" && var.ingress_auth.name != null && var.ingress_auth.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.ingress_auth == null || var.ingress_auth.kind != "offer" || (var.ingress_auth.url != null && var.ingress_auth.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
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
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.service_mesh == null || var.service_mesh.kind != "endpoint" || (var.service_mesh.kind != null && var.service_mesh.kind != "" && var.service_mesh.name != null && var.service_mesh.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.service_mesh == null || var.service_mesh.kind != "offer" || (var.service_mesh.url != null && var.service_mesh.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
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
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.istio_ingress_route_unauthenticated == null || var.istio_ingress_route_unauthenticated.kind != "endpoint" || (var.istio_ingress_route_unauthenticated.kind != null && var.istio_ingress_route_unauthenticated.kind != "" && var.istio_ingress_route_unauthenticated.name != null && var.istio_ingress_route_unauthenticated.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.istio_ingress_route_unauthenticated == null || var.istio_ingress_route_unauthenticated.kind != "offer" || (var.istio_ingress_route_unauthenticated.url != null && var.istio_ingress_route_unauthenticated.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

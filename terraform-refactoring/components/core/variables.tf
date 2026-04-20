# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where core components are deployed"
  type        = string
  nullable    = false
}

variable "minio" {
  description = "Configuration for minio application"
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

variable "envoy" {
  description = "Configuration for envoy application"
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

variable "kubeflow_dashboard" {
  description = "Configuration for kubeflow-dashboard application"
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

variable "kubeflow_profiles" {
  description = "Configuration for kubeflow-profiles application"
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

variable "kubeflow_roles" {
  description = "Configuration for kubeflow-roles application"
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

variable "kubeflow_volumes" {
  description = "Configuration for kubeflow-volumes application"
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

variable "metacontroller_operator" {
  description = "Configuration for metacontroller-operator application"
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
  description = "Ingress provider for core applications (supports same-model endpoint or cross-model offer)"
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

variable "service_mesh" {
  description = "Service mesh provider for core applications from istio-beacon-k8s:service-mesh (supports same-model endpoint or cross-model offer)"
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

variable "istio_ingress_route" {
  description = "Istio ingress route provider for core applications from istio-ingress-k8s:istio-ingress-route (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.istio_ingress_route == null || contains(["endpoint", "offer"], var.istio_ingress_route.kind)
    error_message = "Valid values for istio_ingress_route.kind are (endpoint, offer)."
  }
}

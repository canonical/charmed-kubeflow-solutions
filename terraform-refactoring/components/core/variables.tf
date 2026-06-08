# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "admission_webhook" {
  description = "Configuration for admission-webhook application"
  type = object({
    channel     = optional(string, "1.10/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "model_uuid" {
  description = "UUID of the Juju model where core components are deployed"
  type        = string
  nullable    = false
}

variable "kubeflow_dashboard" {
  description = "Configuration for kubeflow-dashboard application"
  type = object({
    channel     = optional(string, "1.10/stable")
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
    channel     = optional(string, "1.10/stable")
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
    channel     = optional(string, "1.10/stable")
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
    channel     = optional(string, "1.10/stable")
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
    channel     = optional(string, "4.11/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "pvcviewer_operator" {
  description = "Configuration for pvcviewer-operator application"
  type = object({
    channel     = optional(string, "1.10/stable")
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
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.istio_ingress_route == null || var.istio_ingress_route.kind != "endpoint" || (var.istio_ingress_route.kind != null && var.istio_ingress_route.kind != "" && var.istio_ingress_route.name != null && var.istio_ingress_route.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.istio_ingress_route == null || var.istio_ingress_route.kind != "offer" || (var.istio_ingress_route.url != null && var.istio_ingress_route.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "gateway_metadata" {
  description = "Gateway metadata provider for pvcviewer-operator from istio-ingress-k8s:gateway-metadata (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.gateway_metadata == null || contains(["endpoint", "offer"], var.gateway_metadata.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.gateway_metadata == null || var.gateway_metadata.kind != "endpoint" || (var.gateway_metadata.name != null && var.gateway_metadata.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.gateway_metadata == null || var.gateway_metadata.kind != "offer" || (var.gateway_metadata.url != null && var.gateway_metadata.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

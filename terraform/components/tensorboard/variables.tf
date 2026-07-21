variable "model_uuid" {
  description = "UUID of the Juju model where Tensorboard is deployed"
  type        = string
  nullable    = false
}

variable "dashboard_links" {
  description = "Kubeflow Dashboard links provider for tensorboards-web-app from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.dashboard_links == null || contains(["endpoint", "offer"], var.dashboard_links.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.dashboard_links == null || var.dashboard_links.kind != "endpoint" || (var.dashboard_links.name != null && var.dashboard_links.name != "" && var.dashboard_links.endpoint != null && var.dashboard_links.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.dashboard_links == null || var.dashboard_links.kind != "offer" || (var.dashboard_links.url != null && var.dashboard_links.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "ingress" {
  description = "Ingress provider for tensorboards-web-app from istio-pilot:ingress (sidecar; supports same-model endpoint or cross-model offer)"
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
    condition     = var.ingress == null || var.ingress.kind != "endpoint" || (var.ingress.name != null && var.ingress.name != "" && var.ingress.endpoint != null && var.ingress.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.ingress == null || var.ingress.kind != "offer" || (var.ingress.url != null && var.ingress.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "gateway_info" {
  description = "Gateway info provider for tensorboard-controller from istio-pilot:gateway-info (sidecar; supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.gateway_info == null || contains(["endpoint", "offer"], var.gateway_info.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.gateway_info == null || var.gateway_info.kind != "endpoint" || (var.gateway_info.name != null && var.gateway_info.name != "" && var.gateway_info.endpoint != null && var.gateway_info.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.gateway_info == null || var.gateway_info.kind != "offer" || (var.gateway_info.url != null && var.gateway_info.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "gateway_metadata" {
  description = "Gateway metadata provider for tensorboard-controller from istio-ingress-k8s:gateway-metadata (ambient; supports same-model endpoint or cross-model offer)"
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
    condition     = var.gateway_metadata == null || var.gateway_metadata.kind != "endpoint" || (var.gateway_metadata.name != null && var.gateway_metadata.name != "" && var.gateway_metadata.endpoint != null && var.gateway_metadata.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.gateway_metadata == null || var.gateway_metadata.kind != "offer" || (var.gateway_metadata.url != null && var.gateway_metadata.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "istio_ingress_route" {
  description = "Istio ingress route provider for tensorboards-web-app from istio-ingress-k8s:istio-ingress-route (ambient; supports same-model endpoint or cross-model offer)"
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
    condition     = var.istio_ingress_route == null || var.istio_ingress_route.kind != "endpoint" || (var.istio_ingress_route.name != null && var.istio_ingress_route.name != "" && var.istio_ingress_route.endpoint != null && var.istio_ingress_route.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.istio_ingress_route == null || var.istio_ingress_route.kind != "offer" || (var.istio_ingress_route.url != null && var.istio_ingress_route.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "service_mesh" {
  description = "Service mesh provider for Tensorboard applications from istio-beacon-k8s:service-mesh (ambient; supports same-model endpoint or cross-model offer)"
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
    condition     = var.service_mesh == null || var.service_mesh.kind != "endpoint" || (var.service_mesh.name != null && var.service_mesh.name != "" && var.service_mesh.endpoint != null && var.service_mesh.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.service_mesh == null || var.service_mesh.kind != "offer" || (var.service_mesh.url != null && var.service_mesh.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "tensorboard_controller" {
  description = "Configuration for tensorboard-controller application"
  type = object({
    app_name    = optional(string, "tensorboard-controller")
    channel     = optional(string, "1.10/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "tensorboards_web_app" {
  description = "Configuration for tensorboards-web-app application"
  type = object({
    app_name    = optional(string, "tensorboards-web-app")
    channel     = optional(string, "1.10/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

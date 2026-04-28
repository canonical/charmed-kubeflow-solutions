# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where Feast is deployed"
  type        = string
  nullable    = false
}

variable "offline_store" {
  description = "PostgreSQL database provider for feast-integrator offline store from postgresql-k8s:database (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.offline_store == null || contains(["endpoint", "offer"], var.offline_store.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.offline_store == null || var.offline_store.kind != "endpoint" || (var.offline_store.name != null && var.offline_store.name != "" && var.offline_store.endpoint != null && var.offline_store.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.offline_store == null || var.offline_store.kind != "offer" || (var.offline_store.url != null && var.offline_store.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "online_store" {
  description = "PostgreSQL database provider for feast-integrator online store from postgresql-k8s:database (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.online_store == null || contains(["endpoint", "offer"], var.online_store.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.online_store == null || var.online_store.kind != "endpoint" || (var.online_store.name != null && var.online_store.name != "" && var.online_store.endpoint != null && var.online_store.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.online_store == null || var.online_store.kind != "offer" || (var.online_store.url != null && var.online_store.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "registry" {
  description = "PostgreSQL database provider for feast-integrator registry from postgresql-k8s:database (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.registry == null || contains(["endpoint", "offer"], var.registry.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.registry == null || var.registry.kind != "endpoint" || (var.registry.name != null && var.registry.name != "" && var.registry.endpoint != null && var.registry.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.registry == null || var.registry.kind != "offer" || (var.registry.url != null && var.registry.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "secrets" {
  description = "Secrets provider for feast-integrator from resource-dispatcher:secrets (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.secrets == null || contains(["endpoint", "offer"], var.secrets.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.secrets == null || var.secrets.kind != "endpoint" || (var.secrets.name != null && var.secrets.name != "" && var.secrets.endpoint != null && var.secrets.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.secrets == null || var.secrets.kind != "offer" || (var.secrets.url != null && var.secrets.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "pod_defaults" {
  description = "Pod defaults provider for feast-integrator from resource-dispatcher:pod-defaults (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.pod_defaults == null || contains(["endpoint", "offer"], var.pod_defaults.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.pod_defaults == null || var.pod_defaults.kind != "endpoint" || (var.pod_defaults.name != null && var.pod_defaults.name != "" && var.pod_defaults.endpoint != null && var.pod_defaults.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.pod_defaults == null || var.pod_defaults.kind != "offer" || (var.pod_defaults.url != null && var.pod_defaults.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "dashboard_links" {
  description = "Kubeflow Dashboard links provider for feast-ui from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer)"
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
  description = "Ingress provider for feast-ui from istio-pilot:ingress (sidecar; supports same-model endpoint or cross-model offer)"
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

variable "istio_ingress_route" {
  description = "Istio ingress route provider for feast-ui from istio-ingress-k8s:istio-ingress-route (ambient; supports same-model endpoint or cross-model offer)"
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
  description = "Service mesh provider for feast-integrator and feast-ui from istio-beacon-k8s:service-mesh (ambient; supports same-model endpoint or cross-model offer)"
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

variable "feast_integrator" {
  description = "Configuration for feast-integrator application"
  type = object({
    app_name    = optional(string, "feast-integrator")
    channel     = optional(string, "0.49/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "feast_ui" {
  description = "Configuration for feast-ui application"
  type = object({
    app_name    = optional(string, "feast-ui")
    channel     = optional(string, "0.49/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

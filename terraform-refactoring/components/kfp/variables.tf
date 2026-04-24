# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where KFP is deployed"
  type        = string
  nullable    = false
}

variable "mysql_database" {
  description = "MySQL database provider for kfp-api from mysql-k8s:database (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.mysql_database == null || contains(["endpoint", "offer"], var.mysql_database.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.mysql_database == null || var.mysql_database.kind != "endpoint" || (var.mysql_database.kind != null && var.mysql_database.kind != "" && var.mysql_database.name != null && var.mysql_database.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.mysql_database == null || var.mysql_database.kind != "offer" || (var.mysql_database.url != null && var.mysql_database.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "object_storage" {
  description = "Object storage provider for KFP applications from minio:object-storage (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.object_storage == null || contains(["endpoint", "offer"], var.object_storage.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.object_storage == null || var.object_storage.kind != "endpoint" || (var.object_storage.kind != null && var.object_storage.kind != "" && var.object_storage.name != null && var.object_storage.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.object_storage == null || var.object_storage.kind != "offer" || (var.object_storage.url != null && var.object_storage.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "dashboard_links" {
  description = "Kubeflow Dashboard links provider for kfp-ui from kubeflow-dashboard:dashboard-links (supports same-model endpoint or cross-model offer)"
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
    condition     = var.dashboard_links == null || var.dashboard_links.kind != "endpoint" || (var.dashboard_links.kind != null && var.dashboard_links.kind != "" && var.dashboard_links.name != null && var.dashboard_links.name != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.dashboard_links == null || var.dashboard_links.kind != "offer" || (var.dashboard_links.url != null && var.dashboard_links.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "service_mesh" {
  description = "Service mesh provider for KFP applications from istio-beacon-k8s:service-mesh (supports same-model endpoint or cross-model offer)"
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
  description = "Istio ingress route provider for kfp-ui from istio-ingress-k8s:istio-ingress-route (supports same-model endpoint or cross-model offer)"
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

variable "ingress" {
  description = "Ingress provider for kfp-ui from istio-pilot:ingress (supports same-model endpoint or cross-model offer)"
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

variable "argo_controller" {
  description = "Configuration for argo-controller application"
  type = object({
    app_name    = optional(string, "argo-controller")
    channel     = optional(string, "3.7/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "envoy" {
  description = "Configuration for envoy application"
  type = object({
    app_name    = optional(string, "envoy")
    channel     = optional(string, "2.4/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "mlmd" {
  description = "Configuration for mlmd application"
  type = object({
    app_name    = optional(string, "mlmd")
    channel     = optional(string, "ckf-1.10/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string)
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "kfp_api" {
  description = "Configuration for kfp-api application"
  type = object({
    app_name    = optional(string, "kfp-api")
    channel     = optional(string, "2.15/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "kfp_metadata_writer" {
  description = "Configuration for kfp-metadata-writer application"
  type = object({
    app_name    = optional(string, "kfp-metadata-writer")
    channel     = optional(string, "2.15/stable")
    revision    = optional(number, null)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "kfp_persistence" {
  description = "Configuration for kfp-persistence application"
  type = object({
    app_name    = optional(string, "kfp-persistence")
    channel     = optional(string, "2.15/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "kfp_profile_controller" {
  description = "Configuration for kfp-profile-controller application"
  type = object({
    app_name    = optional(string, "kfp-profile-controller")
    channel     = optional(string, "2.15/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "kfp_schedwf" {
  description = "Configuration for kfp-schedwf application"
  type = object({
    app_name    = optional(string, "kfp-schedwf")
    channel     = optional(string, "2.15/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "kfp_ui" {
  description = "Configuration for kfp-ui application"
  type = object({
    app_name    = optional(string, "kfp-ui")
    channel     = optional(string, "2.15/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "kfp_viewer" {
  description = "Configuration for kfp-viewer application"
  type = object({
    app_name    = optional(string, "kfp-viewer")
    channel     = optional(string, "2.15/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "kfp_viz" {
  description = "Configuration for kfp-viz application"
  type = object({
    app_name    = optional(string, "kfp-viz")
    channel     = optional(string, "2.15/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

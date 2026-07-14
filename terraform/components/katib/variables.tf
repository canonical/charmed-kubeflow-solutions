variable "model_uuid" {
  description = "UUID of the Juju model where Katib is deployed"
  type        = string
  nullable    = false
}

variable "mysql_database" {
  description = "MySQL database provider for katib-db-manager from mysql-k8s:database (supports same-model endpoint or cross-model offer)"
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

variable "dashboard_links" {
  description = "Kubeflow Dashboard links provider for katib-ui from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer)"
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

variable "ingress" {
  description = "Ingress provider for katib-ui from istio-pilot:ingress (supports same-model endpoint or cross-model offer)"
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

variable "istio_ingress_route" {
  description = "Istio ingress route provider for katib-ui from istio-ingress-k8s:istio-ingress-route (supports same-model endpoint or cross-model offer)"
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

variable "service_mesh" {
  description = "Service mesh provider for Katib applications from istio-beacon-k8s:service-mesh (supports same-model endpoint or cross-model offer)"
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

variable "katib_controller" {
  description = "Configuration for katib-controller application"
  type = object({
    app_name    = optional(string, "katib-controller")
    channel     = optional(string, "0.19/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "katib_db_manager" {
  description = "Configuration for katib-db-manager application"
  type = object({
    app_name    = optional(string, "katib-db-manager")
    channel     = optional(string, "0.19/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "katib_ui" {
  description = "Configuration for katib-ui application"
  type = object({
    app_name    = optional(string, "katib-ui")
    channel     = optional(string, "0.19/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where MLflow is deployed"
  type        = string
  nullable    = false
}

variable "mysql_database" {
  description = "MySQL database provider for mlflow-server from mysql-k8s:database (supports same-model endpoint or cross-model offer)"
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
    condition     = var.mysql_database == null || var.mysql_database.kind != "endpoint" || (var.mysql_database.name != null && var.mysql_database.name != "" && var.mysql_database.endpoint != null && var.mysql_database.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.mysql_database == null || var.mysql_database.kind != "offer" || (var.mysql_database.url != null && var.mysql_database.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "object_storage" {
  description = "Object storage provider for mlflow-server from minio:object-storage (supports same-model endpoint or cross-model offer)"
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
    condition     = var.object_storage == null || var.object_storage.kind != "endpoint" || (var.object_storage.name != null && var.object_storage.name != "" && var.object_storage.endpoint != null && var.object_storage.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.object_storage == null || var.object_storage.kind != "offer" || (var.object_storage.url != null && var.object_storage.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "ingress" {
  description = "Ingress provider for mlflow-server from istio-pilot:ingress (sidecar; supports same-model endpoint or cross-model offer)"
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
  description = "Istio ingress route provider for mlflow-server from istio-ingress-k8s:istio-ingress-route (ambient; supports same-model endpoint or cross-model offer)"
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
  description = "Service mesh provider for mlflow-server from istio-beacon-k8s:service-mesh (ambient; supports same-model endpoint or cross-model offer)"
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

variable "secrets" {
  description = "Secrets provider for mlflow-server from resource-dispatcher:secrets (supports same-model endpoint or cross-model offer)"
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
  description = "Pod defaults provider for mlflow-server from resource-dispatcher:pod-defaults (supports same-model endpoint or cross-model offer)"
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

variable "mlflow_server" {
  description = "Configuration for mlflow-server application"
  type = object({
    app_name    = optional(string, "mlflow-server")
    channel     = optional(string, "2.22/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

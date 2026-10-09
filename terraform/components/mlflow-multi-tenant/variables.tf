# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where MLflow is deployed"
  type        = string
  nullable    = false
}

variable "postgresql_database" {
  description = "PostgreSQL database provider for mlflow-server from postgresql-k8s:database (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.postgresql_database == null || contains(["endpoint", "offer"], var.postgresql_database.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.postgresql_database == null || var.postgresql_database.kind != "endpoint" || (var.postgresql_database.name != null && var.postgresql_database.name != "" && var.postgresql_database.endpoint != null && var.postgresql_database.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.postgresql_database == null || var.postgresql_database.kind != "offer" || (var.postgresql_database.url != null && var.postgresql_database.url != "")
    error_message = "The 'url' attribute must be provided for a cross-model offer integration."
  }
}

variable "s3_credentials" {
  description = "S3 credentials provider for mlflow-server from s3-integrator:s3-credentials (supports same-model endpoint or cross-model offer)"
  type = object({
    kind     = string
    name     = optional(string, null)
    endpoint = optional(string, null)
    url      = optional(string, null)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.s3_credentials == null || contains(["endpoint", "offer"], var.s3_credentials.kind)
    error_message = "The 'kind' attribute must be either 'endpoint' or 'offer'."
  }

  validation {
    condition     = var.s3_credentials == null || var.s3_credentials.kind != "endpoint" || (var.s3_credentials.name != null && var.s3_credentials.name != "" && var.s3_credentials.endpoint != null && var.s3_credentials.endpoint != "")
    error_message = "Both 'name' and 'endpoint' attributes must be provided for an in-model integration."
  }

  validation {
    condition     = var.s3_credentials == null || var.s3_credentials.kind != "offer" || (var.s3_credentials.url != null && var.s3_credentials.url != "")
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

variable "dashboard_links" {
  description = "Kubeflow Dashboard links provider for mlflow-server from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer)"
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

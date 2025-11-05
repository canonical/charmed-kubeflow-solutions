variable "risk" {
  type        = string
  description = "Value for the risk to be used"
  default     = "stable"

  validation {
    condition     = contains(["stable", "candidate", "beta", "edge"], var.risk)
    error_message = "Valid values for var: risk are (stable, candidate, beta and edge)."
  }
}

variable "model" {
  type        = string
  description = "Name for the model to be used"
  default     = "kubeflow"
}

variable "admission_webhook" {
  type = object({
    name           = optional(string, "admission-webhook")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Admission webhook. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "argo_controller" {
  type = object({
    name           = optional(string, "argo-controller")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "dex_auth" {
  type = object({
    name           = optional(string, "dex-auth")
    channel            = optional(string)
    config             = optional(map(string), {
      # "public-url" : var.public_url,
      # "connectors" : var.dex_connectors,
      "static-username" : "admin",
      "static-password" : "p4ssw0rd"
    })
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "envoy" {
  type = object({
    name           = optional(string, "envoy")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "istio_gateway" {
  type = object({
    name           = optional(string, "istio-gateway")
    channel            = optional(string)
    config             = optional(map(string), {
      kind        = "ingress",
      # annotations = var.istio_ingressgateway_annotations,
    })
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "istio_pilot" {
  type = object({
    name           = optional(string, "istio-pilot")
    channel            = optional(string)
    config             = optional(map(string), {
      default-gateway = "kubeflow-gateway",
      # "tls-secret-id" : var.istio_tls_secret_id
    })
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}


variable "kubeflow_dashboard" {
  type = object({
    name           = optional(string, "kubeflow-dashboard")
    channel            = optional(string)
    config             = optional(map(string), {
      # "registration-flow" : var.kubeflow_dashboard_registration_flow
    })
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "kubeflow_profiles" {
  type = object({
    name           = optional(string, "kubeflow-profiles")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "kubeflow_roles" {
  type = object({
    name           = optional(string, "kubeflow-roles")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "kubeflow_volumes" {
  type = object({
    name           = optional(string, "kubeflow-volumes")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "metacontroller_operator" {
  type = object({
    name           = optional(string, "metacontroller-operator")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "mlmd" {
  type = object({
    name           = optional(string, "mlmd")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    storage_directives = optional(map(string), {
      mlmd-data = "10G"
    })
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "minio" {
  type = object({
    name           = optional(string, "minio")
    channel            = optional(string)
    config             = optional(map(string), {
      # access-key               = var.minio_access_key,
      # secret-key               = var.minio_secret_key,
      # mode                     = var.minio_mode,
      # gateway-storage-service  = var.minio_gateway_storage_service,
      # storage-service-endpoint = var.minio_storage_service_endpoint,
    })
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    storage_directives = optional(map(string), {
      minio-data = "10G"
    })
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "oidc_gatekeeper" {
  type = object({
    name           = optional(string, "oidc-gatekeeper")
    channel            = optional(string)
    config             = optional(map(string), {
      # ca-bundle = var.oidc_gatekeeper_ca_bundle,
    })
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "pvcviewer_operator" {
  type = object({
    name           = optional(string, "pvcviewer-operator")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

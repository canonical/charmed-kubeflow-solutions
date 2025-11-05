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

variable "ingress" {
  description = "Pointers to the ingress"
  type = object({
    kind = optional(string, "endpoint")
    name = optional(string, "ingress")
    endpoint = optional(string, "ingress")
  })

  validation {
    condition     = contains(["endpoint"], var.ingress.kind)
    error_message = "Valid values for var: ingress.kind are (endpoint, offer)"
  }

}

variable "dashboard_links" {
  description = "Pointers to the dashboard links"
  type = object({
    kind = optional(string, "endpoint")
    name = optional(string, "kubeflow-dashboard")
    endpoint = optional(string, "links")
  })

  validation {
    condition     = contains(["endpoint"], var.dashboard_links.kind)
    error_message = "Valid values for var: dashboard_links.kind are (endpoint, offer)"
  }

}


variable "db" {
  description = "Database settings"
  type = object({
    deployed = optional(string, "bundled")
    info = optional(object({
      name = optional(string, null)
      endpoint  = optional(string, null)
      revision = optional(number, null)
      storage_size = optional(string, null)
    }), {})
    tls = optional(object({
      cert = optional(string, "")
      key  = optional(string, "")
      ca   = optional(string, "")
    }), {})
  })
  default = { deployed = "bundled", info = {name=null, endpoint=null}}

  validation {
    condition     = contains(["external", "bundled"], var.db.deployed)
    error_message = "Valid values for var: cos.deployed are (external, bundled)"
  }

  validation {
    condition = var.db.deployed != "external" || alltrue([
      var.db.info.name != null,
      var.db.info.endpoint != null,
    ])
    error_message = "When using external db, please define all fields in the offer variables"
  }
}

variable "katib_controller" {
  type = object({
    name           = optional(string, "katib-controller")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "katib_db_manager" {
  type = object({
    name           = optional(string, "katib-db-manager")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "katib_ui" {
  type = object({
    name           = optional(string, "katib-ui")
    channel            = optional(string)
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

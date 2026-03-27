
variable "model_uuid" {
  type        = string
  description = "Name for the model to be used"
  default     = "kubeflow"
}

variable "ingress" {
  description = "Pointers to the ingress"
  type = object({
    kind = string
    name = optional(string, null)
    endpoint = optional(string, null)
    url = optional(string, null)
  })

  validation {
    condition     = contains(["endpoint", "offer"], var.ingress.kind)
    error_message = "Valid values for var: ingress.kind are (endpoint, offer)"
  }

  validation {
    condition     = var.ingress.kind != "endpoint" || (
      var.ingress.name != null && var.ingress.endpoint != null
    )
    error_message = "When using endpoint kind, name and endpoint must be valued"
  }

  validation {
    condition     = var.ingress.kind != "offer" || (
      var.ingress.url != null
    )
    error_message = "When using offer kind, url must be valued"
  }

}

variable "dashboard_links" {
  description = "Pointers to the dashboard links"
  type = object({
    kind = string
    name = optional(string, null)
    endpoint = optional(string, null)
    url = optional(string, null)
  })

  validation {
    condition     = contains(["endpoint", "offer"], var.dashboard_links.kind)
    error_message = "Valid values for var: dashboard_links.kind are (endpoint, offer)"
  }

  validation {
    condition     = var.dashboard_links.kind != "endpoint" || (
      var.dashboard_links.name != null && var.dashboard_links.endpoint != null
    )
    error_message = "When using endpoint kind, name and endpoint must be valued"
  }

  validation {
    condition     = var.dashboard_links.kind != "offer" || (
      var.dashboard_links.url != null
    )
    error_message = "When using offer kind, url must be valued"
  }
}


variable "db" {
  description = "Pointers to the dashboard links"
  type = object({
    kind = string
    name = optional(string, null)
    endpoint = optional(string, null)
    url = optional(string, null)
  })

  validation {
    condition     = contains(["endpoint", "offer"], var.db.kind)
    error_message = "Valid values for var: db.kind are (endpoint, offer)"
  }

  validation {
    condition     = var.db.kind != "endpoint" || (
      var.db.name != null && var.db.endpoint != null
    )
    error_message = "When using endpoint kind, name and endpoint must be valued"
  }

  validation {
    condition     = var.db.kind != "offer" || (
      var.db.url != null
    )
    error_message = "When using offer kind, url must be valued"
  }
}

variable "controller" {
  type = object({
    name               = optional(string, "katib-controller")
    channel            = optional(string, "0.18/stable")
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"

  validation {
    condition = var.controller.name != null
    error_message = "name attribute cannot be null"
  }

  validation {
    condition = var.controller.channel != null
    error_message = "channel attribute cannot be null"
  }
}

variable "db_manager" {
  type = object({
    name               = optional(string, "katib-db-manager")
    channel            = optional(string, "0.18/stable")
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"

  validation {
    condition = var.db_manager.name != null
    error_message = "name attribute cannot be null"
  }

  validation {
    condition = var.db_manager.channel != null
    error_message = "channel attribute cannot be null"
  }
}

variable "ui" {
  type = object({
    name               = optional(string, "katib-ui")
    channel            = optional(string, "0.18/stable")
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {})
  })
  default     = {}
  description = "Application configuration for Argo controller. For more details: https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application"
}

variable "risk" {
  type        = string
  description = "Value for the risk to be used"
  default     = null
  nullable    = true

  validation {
    condition     = var.risk == null || contains(["stable", "candidate", "beta", "edge"], var.risk)
    error_message = "Valid values for var: risk are (stable, candidate, beta and edge)."
  }
}


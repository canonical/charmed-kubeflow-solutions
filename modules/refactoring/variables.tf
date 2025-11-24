variable "proxy" {
  type = object({
    http = optional(string)
    https = optional(string)
    no-proxy = optional(string)
  })
  default = {}
}

variable "juju_controller" {
  type = object({
    endpoint = optional(string)
    username = optional(string)
    password = optional(string)
    ca = optional(string)
  })
  default = {}
}

variable "components" {
  type = list(string)
  default = []
}

variable "katib" {
  type = object({
    enable = optional(bool, true)
    db = optional(string, "private")
    db_offer = optional(string, null)
    ui = optional(any, {})
    controller = optional(any, {})
    db_manager = optional(any, {})
  })

  validation {
    condition     = contains(["shared", "private"], var.katib.db)
    error_message = "Valid values for var: katib.db are (shared, private)"
  }

  validation {
    condition = var.katib.db != "shared" || var.katib.db_offer != null
    error_message = "When db_offer is provided, db must be shared."
  }

}

variable "katib_db" {
  type = object({
    name               = optional(string, "katib-db")
    channel            = optional(string, "8.0/stable")
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {}) # non-compliant
    storage_size       = optional(string, "10G") # non-compliant
  })
  default     = {"config": {profile-limit-memory = "2048"}}
  description = "Application configuration for the private Katib Db controller."

  validation {
    condition = var.katib_db.name != null
    error_message = "name attribute cannot be null"
  }

  validation {
    condition = var.katib_db.channel != null
    error_message = "channel attribute cannot be null"
  }
}

variable "central_db" {
  type = object({
    name               = optional(string, "mysql")
    channel            = optional(string, "8.0/stable")
    config             = optional(map(string), {})
    constraints        = optional(string, "arch=amd64")
    revision           = optional(number, null)
    # storage_directives = optional(map(string), {}) # non-compliant
    storage_size       = optional(string, "10G") # non-compliant
  })
  default     = {"config": {profile-limit-memory = "2048"}}
  description = "Application configuration for the private Katib Db controller."

  validation {
    condition = var.central_db.name != null
    error_message = "name attribute cannot be null"
  }

  validation {
    condition = var.central_db.channel != null
    error_message = "channel attribute cannot be null"
  }
}

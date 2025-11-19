variable "components" {
  type = list(string)
  default = []
}

variable "db" {
  description = "Database settings"
  type = object({
    deployed = optional(string, "shared")
    info = optional(object({
      name = optional(string, "mysql")
      endpoint  = optional(string, "database")
      revision = optional(number, null)
      storage_size = optional(string, "10G")
    }), {})
    tls = optional(object({
      cert = optional(string, "")
      key  = optional(string, "")
      ca   = optional(string, "")
    }), {})
  })
  default = { deployed = "shared", info = {name="mysql",endpoint="database", revision=null, storage_size="10G"} }

  validation {
    condition     = contains(["external", "shared", "private"], var.db.deployed)
    error_message = "Valid values for var: db.deployed are (external, shared, private)"
  }

  validation {
    condition = var.db.deployed != "external" || alltrue([
      var.db.offer.name != null,
      var.db.offer.endpoint != null,
    ])
    error_message = "When using external db, please define all fields in the offer variables"
  }
}

variable "http_proxy" {
  type = string
  description = "Address for the http proxy"
  default = ""
}

variable "https_proxy" {
  type = string
  description = "Address for the https proxy"
  default = ""
}

variable "no_proxy" {
  type = string
  description = "Addresses to not be proxies"
  default = ""
}
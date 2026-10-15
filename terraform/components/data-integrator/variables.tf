# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "Reference to an existing model uuid."
  type        = string
  nullable    = false
}

variable "data_integrator" {
  description = "Configuration for data-integrator application"
  type = object({
    app_name    = optional(string, "data-integrator")
    channel     = optional(string, "latest/edge")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, false)
    constraints = optional(string)
    config      = optional(map(string), {})
  })
  default = {}
}

variable "mlflow_server_endpoint" {
  type = object({
    name               = string
    endpoint           = string
  })
  default = null
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "Reference to an existing model uuid."
  type        = string
  nullable    = false
}

variable "profile" {
  description = "Name of profiles to apply this to"
  type        = string
  default     = "*"
}

variable "data_kubeflow_integrator" {
  description = "Configuration for data-kubeflow-integrator application"
  type = object({
    app_name    = optional(string, "data-kubeflow-integrator")
    channel     = optional(string, "1/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, false)
    constraints = optional(string)
    config      = optional(map(string), {})
  })
  default = {}
}

variable "mysql" {
  type = object({
    kind             = string
    name             = optional(string, null)
    endpoint         = optional(string, null)
    url              = optional(string, null)
    database_name    = optional(string, null)
    extra_user_roles = optional(string, null)
  })
  default = null

  validation {
    condition = (
      var.mysql == null ||
      (
        contains(["endpoint", "offer"], var.mysql.kind) &&
        (var.mysql.kind != "endpoint" || (var.mysql.name != null && var.mysql.endpoint != null)) &&
        (var.mysql.kind != "offer" || var.mysql.url != null)
      )
    )
    error_message = "If mysql is set, kind must be 'endpoint' (requires name and endpoint) or 'offer' (requires url)."
  }
}

variable "postgresql" {
  type = object({
    kind             = string
    name             = optional(string, null)
    endpoint         = optional(string, null)
    url              = optional(string, null)
    database_name    = optional(string, null)
    extra_user_roles = optional(string, null)
  })
  default = null

  validation {
    condition = (
      var.postgresql == null ||
      (
        contains(["endpoint", "offer"], var.postgresql.kind) &&
        (var.postgresql.kind != "endpoint" || (var.postgresql.name != null && var.postgresql.endpoint != null)) &&
        (var.postgresql.kind != "offer" || var.postgresql.url != null)
      )
    )
    error_message = "If postgresql is set, kind must be 'endpoint' (requires name and endpoint) or 'offer' (requires url)."
  }
}

variable "spark" {
  type = object({
    kind            = string
    name            = optional(string, null)
    endpoint        = optional(string, null)
    url             = optional(string, null)
    service_account = optional(string, null)
  })
  default = null

  validation {
    condition = (
      var.spark == null ||
      (
        contains(["endpoint", "offer"], var.spark.kind) &&
        (var.spark.kind != "endpoint" || (var.spark.name != null && var.spark.endpoint != null)) &&
        (var.spark.kind != "offer" || var.spark.url != null)
      )
    )
    error_message = "If spark is set, kind must be 'endpoint' (requires name and endpoint) or 'offer' (requires url)."
  }
}

variable "resource_dispatcher_endpoints" {
  description = "Pointers for the resource dispatcher endpoints"
  type = map(object({
    name     = string
    endpoint = string
  }))
  default = {}
}
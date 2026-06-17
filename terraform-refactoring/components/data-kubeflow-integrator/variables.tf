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
}

variable "resource_dispatcher_endpoints" {
  description = "Pointers for the resource dispatcher endpoints"
  type = map(object({
    name = string
    endpoint = string
  }))
  default = {}
}
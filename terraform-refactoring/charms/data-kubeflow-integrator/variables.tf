# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "app_name" {
  description = "Name to give the deployed application."
  type        = string
  default     = "data-kubeflow-integrator"
  nullable    = false
}

variable "channel" {
  description = "Channel of the charm."
  type        = string
  default     = "1/stable"
  nullable    = false
}

variable "model_uuid" {
  description = "Reference to an existing model uuid."
  type        = string
  nullable    = false
}

variable "revision" {
  description = "Revision number of the charm."
  type        = number
  default     = null
}

variable "profile" {
  description = "Name of profiles to apply this to"
  type        = string
  default     = "*"
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
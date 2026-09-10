# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "app_name" {
  description = "Name to give the deployed application."
  type        = string
  default     = "resource-dispatcher"
  nullable    = false
}

variable "channel" {
  description = "Channel of the charm."
  type        = string
  default     = "2.0/stable"
  nullable    = false
}

variable "config" {
  description = "Map for configuration options."
  type        = map(string)
  default     = {}
}

variable "constraints" {
  description = "String listing constraints for this application."
  type        = string
  default     = null
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

variable "trust" {
  description = "Whether the application should be trusted."
  type        = bool
  default     = true
}

variable "units" {
  description = "Unit count."
  type        = number
  default     = 1
}

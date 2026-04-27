# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# KServe Controller application
resource "juju_application" "kserve_controller" {
  charm {
    name     = "kserve-controller"
    channel  = var.kserve_controller.channel
    revision = var.kserve_controller.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kserve_controller.app_name
  units       = var.kserve_controller.units
  trust       = var.kserve_controller.trust
  constraints = var.kserve_controller.constraints
  config      = var.kserve_controller.config
  resources   = var.kserve_controller.resources
}

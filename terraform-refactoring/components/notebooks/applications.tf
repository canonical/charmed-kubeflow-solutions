# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Notebook Controller application
resource "juju_application" "jupyter_controller" {
  charm {
    name     = "jupyter-controller"
    channel  = var.jupyter_controller.channel
    revision = var.jupyter_controller.revision
  }

  model_uuid  = var.model_uuid
  name        = var.jupyter_controller.app_name
  units       = var.jupyter_controller.units
  trust       = var.jupyter_controller.trust
  constraints = var.jupyter_controller.constraints
  config      = var.jupyter_controller.config
  resources   = var.jupyter_controller.resources
}

# Notebook Web App application
resource "juju_application" "jupyter_ui" {
  charm {
    name     = "jupyter-ui"
    channel  = var.jupyter_ui.channel
    revision = var.jupyter_ui.revision
  }

  model_uuid  = var.model_uuid
  name        = var.jupyter_ui.app_name
  units       = var.jupyter_ui.units
  trust       = var.jupyter_ui.trust
  constraints = var.jupyter_ui.constraints
  config      = var.jupyter_ui.config
  resources   = var.jupyter_ui.resources
}

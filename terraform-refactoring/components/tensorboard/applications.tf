# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Tensorboard Controller application
resource "juju_application" "tensorboard_controller" {
  charm {
    name     = "tensorboard-controller"
    channel  = var.tensorboard_controller.channel
    revision = var.tensorboard_controller.revision
  }

  model_uuid  = var.model_uuid
  name        = var.tensorboard_controller.app_name
  units       = var.tensorboard_controller.units
  trust       = var.tensorboard_controller.trust
  constraints = var.tensorboard_controller.constraints
  config      = var.tensorboard_controller.config
  resources   = var.tensorboard_controller.resources
}

# Tensorboards Web App application
resource "juju_application" "tensorboards_web_app" {
  charm {
    name     = "tensorboards-web-app"
    channel  = var.tensorboards_web_app.channel
    revision = var.tensorboards_web_app.revision
  }

  model_uuid  = var.model_uuid
  name        = var.tensorboards_web_app.app_name
  units       = var.tensorboards_web_app.units
  trust       = var.tensorboards_web_app.trust
  constraints = var.tensorboards_web_app.constraints
  config      = var.tensorboards_web_app.config
  resources   = var.tensorboards_web_app.resources
}

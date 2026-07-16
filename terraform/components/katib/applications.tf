# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Katib Controller application
resource "juju_application" "katib_controller" {
  charm {
    name     = "katib-controller"
    channel  = var.katib_controller.channel
    revision = var.katib_controller.revision
  }

  model_uuid  = var.model_uuid
  name        = var.katib_controller.app_name
  units       = var.katib_controller.units
  trust       = var.katib_controller.trust
  constraints = var.katib_controller.constraints
  config      = var.katib_controller.config
  resources   = var.katib_controller.resources
}

# Katib DB Manager application
resource "juju_application" "katib_db_manager" {
  charm {
    name     = "katib-db-manager"
    channel  = var.katib_db_manager.channel
    revision = var.katib_db_manager.revision
  }

  model_uuid  = var.model_uuid
  name        = var.katib_db_manager.app_name
  units       = var.katib_db_manager.units
  trust       = var.katib_db_manager.trust
  constraints = var.katib_db_manager.constraints
  config      = var.katib_db_manager.config
  resources   = var.katib_db_manager.resources
}

# Katib UI application
resource "juju_application" "katib_ui" {
  charm {
    name     = "katib-ui"
    channel  = var.katib_ui.channel
    revision = var.katib_ui.revision
  }

  model_uuid  = var.model_uuid
  name        = var.katib_ui.app_name
  units       = var.katib_ui.units
  trust       = var.katib_ui.trust
  constraints = var.katib_ui.constraints
  config      = var.katib_ui.config
  resources   = var.katib_ui.resources
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Feast Integrator application
resource "juju_application" "feast_integrator" {
  charm {
    name     = "feast-integrator"
    channel  = var.feast_integrator.channel
    revision = var.feast_integrator.revision
  }

  model_uuid  = var.model_uuid
  name        = var.feast_integrator.app_name
  units       = var.feast_integrator.units
  trust       = var.feast_integrator.trust
  constraints = var.feast_integrator.constraints
  config      = var.feast_integrator.config
  resources   = var.feast_integrator.resources
}

# Feast UI application
resource "juju_application" "feast_ui" {
  charm {
    name     = "feast-ui"
    channel  = var.feast_ui.channel
    revision = var.feast_ui.revision
  }

  model_uuid  = var.model_uuid
  name        = var.feast_ui.app_name
  units       = var.feast_ui.units
  trust       = var.feast_ui.trust
  constraints = var.feast_ui.constraints
  config      = var.feast_ui.config
  resources   = var.feast_ui.resources
}

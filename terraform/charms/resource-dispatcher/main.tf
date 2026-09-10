# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_application" "resource_dispatcher" {
  name       = var.app_name
  model_uuid = var.model_uuid

  charm {
    name     = "resource-dispatcher"
    channel  = var.channel
    revision = var.revision
  }

  config      = var.config
  units       = var.units
  trust       = var.trust
  constraints = var.constraints
}

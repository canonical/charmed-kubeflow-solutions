# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_application" "minio" {
  name       = var.app_name
  model_uuid = var.model_uuid

  charm {
    name     = "minio"
    channel  = var.channel
    revision = var.revision
    base     = var.base
  }

  config      = var.config
  units       = var.units
  trust       = var.trust
  constraints = var.constraints
  storage_directives = var.storage_directives
}


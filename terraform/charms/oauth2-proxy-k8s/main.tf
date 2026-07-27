# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_application" "oauth2_proxy" {
  name       = var.app_name
  model_uuid = var.model_uuid

  charm {
    name     = "oauth2-proxy-k8s"
    channel  = var.channel
    revision = var.revision
    base     = var.base
  }

  config      = var.config
  resources   = var.resources
  units       = var.units
  trust       = var.trust
  constraints = var.constraints
}

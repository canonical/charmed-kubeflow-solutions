# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_application" "istio_k8s" {
  name       = var.app_name
  model_uuid = var.model_uuid

  charm {
    name     = "istio-k8s"
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

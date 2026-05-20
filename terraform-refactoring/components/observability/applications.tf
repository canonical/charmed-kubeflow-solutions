# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_application" "opentelemetry_collector_k8s" {
  charm {
    name     = "opentelemetry-collector-k8s"
    channel  = var.opentelemetry_collector_k8s.channel
    revision = var.opentelemetry_collector_k8s.revision
  }

  model_uuid  = var.model_uuid
  name        = "opentelemetry-collector-k8s"
  units       = var.opentelemetry_collector_k8s.units
  trust       = var.opentelemetry_collector_k8s.trust
  constraints = var.opentelemetry_collector_k8s.constraints
  config      = var.opentelemetry_collector_k8s.config
  resources   = var.opentelemetry_collector_k8s.resources

  storage_directives = {
    persisted = var.opentelemetry_collector_k8s.storage_size
  }
}

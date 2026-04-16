# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Istio Pilot to Istio Gateway integration
resource "juju_integration" "istio_pilot_istio_gateway" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.istio_pilot.name
    endpoint = "istio-pilot"
  }

  application {
    name     = juju_application.istio_gateway.name
    endpoint = "istio-pilot"
  }
}

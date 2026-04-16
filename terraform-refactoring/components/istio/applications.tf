# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Istio Pilot application (control plane)
resource "juju_application" "istio_pilot" {
  charm {
    name     = "istio-pilot"
    channel  = "1.28/${var.risk}"
    revision = var.istio_pilot.revision
  }

  model_uuid  = var.model_uuid
  name        = "istio-pilot"
  units       = var.istio_pilot.units
  trust       = var.istio_pilot.trust
  constraints = var.istio_pilot.constraints
  config      = var.istio_pilot.config
  resources   = var.istio_pilot.resources
}

# Istio Gateway application (ingress gateway)
resource "juju_application" "istio_gateway" {
  charm {
    name     = "istio-gateway"
    channel  = "1.28/${var.risk}"
    revision = var.istio_gateway.revision
  }

  model_uuid  = var.model_uuid
  name        = "istio-gateway"
  units       = var.istio_gateway.units
  trust       = var.istio_gateway.trust
  constraints = var.istio_gateway.constraints
  config      = var.istio_gateway.config
  resources   = var.istio_gateway.resources
}

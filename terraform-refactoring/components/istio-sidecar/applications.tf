# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Istio Pilot application (control plane)
resource "juju_application" "istio_pilot" {
  charm {
    name     = "istio-pilot"
    channel  = var.istio_pilot.channel
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
resource "juju_application" "istio_ingressgateway" {
  charm {
    name     = "istio-gateway"
    channel  = var.istio_ingressgateway.channel
    revision = var.istio_ingressgateway.revision
  }

  model_uuid  = var.model_uuid
  name        = "istio-ingressgateway"
  units       = var.istio_ingressgateway.units
  trust       = var.istio_ingressgateway.trust
  constraints = var.istio_ingressgateway.constraints
  config      = var.istio_ingressgateway.config
  resources   = var.istio_ingressgateway.resources
}

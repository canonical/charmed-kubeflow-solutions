# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Istio K8s application
resource "juju_application" "istio_k8s" {
  charm {
    name     = "istio-k8s"
    channel  = var.istio_k8s.channel
    revision = var.istio_k8s.revision
  }

  model_uuid  = var.model_uuid
  name        = "istio-k8s"
  units       = var.istio_k8s.units
  trust       = var.istio_k8s.trust
  constraints = var.istio_k8s.constraints
  config = var.istio_k8s_platform != "" ? {
    platform = var.istio_k8s_platform
  } : {}
  resources   = var.istio_k8s.resources
}

# Istio Ingress K8s application
resource "juju_application" "istio_ingress_k8s" {
  charm {
    name     = "istio-ingress-k8s"
    channel  = var.istio_ingress_k8s.channel
    revision = var.istio_ingress_k8s.revision
  }

  model_uuid  = var.model_uuid
  name        = "istio-ingress-k8s"
  units       = var.istio_ingress_k8s.units
  trust       = var.istio_ingress_k8s.trust
  constraints = var.istio_ingress_k8s.constraints
  config      = var.istio_ingress_k8s.config
  resources   = var.istio_ingress_k8s.resources
}

# Istio Beacon K8s application
resource "juju_application" "istio_beacon_k8s" {
  charm {
    name     = "istio-beacon-k8s"
    channel  = var.istio_beacon_k8s.channel
    revision = var.istio_beacon_k8s.revision
  }

  model_uuid  = var.model_uuid
  name        = "istio-beacon-k8s"
  units       = var.istio_beacon_k8s.units
  trust       = var.istio_beacon_k8s.trust
  constraints = var.istio_beacon_k8s.constraints
  config      = var.istio_beacon_k8s.config
  resources   = var.istio_beacon_k8s.resources
}

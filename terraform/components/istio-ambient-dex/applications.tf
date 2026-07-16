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
  config      = var.istio_k8s.config
  resources   = var.istio_k8s.resources
}

# Istio Ingress K8s gateway, deployed via the upstream istio-ingress-k8s
# Terraform module (ref pinned to match components/istio-ambient). The upstream
# module hardcodes trust = true and does not accept base/resources, so
# var.istio_ingress_k8s.trust and .resources are intentionally not passed.
module "istio_ingress_k8s" {
  source = "git::https://github.com/canonical/istio-ingress-k8s-operator//terraform?ref=a9ef9646aea149a00a6a7620acaf483249714d04"

  model_uuid  = var.model_uuid
  app_name    = "istio-ingress-k8s"
  channel     = var.istio_ingress_k8s.channel
  revision    = var.istio_ingress_k8s.revision
  units       = var.istio_ingress_k8s.units
  constraints = var.istio_ingress_k8s.constraints
  config      = var.istio_ingress_k8s.config
}

# Istio Beacon K8s, deployed via the upstream istio-beacon-k8s Terraform module
# (ref pinned to match components/istio-ambient). trust is hardcoded upstream
# and base/resources are unsupported, so those fields are not passed.
module "istio_beacon_k8s" {
  source = "git::https://github.com/canonical/istio-beacon-k8s-operator//terraform?ref=51b204dd50392809692263f6e973d81dd9fe200a"

  model_uuid  = var.model_uuid
  app_name    = "istio-beacon-k8s"
  channel     = var.istio_beacon_k8s.channel
  revision    = var.istio_beacon_k8s.revision
  units       = var.istio_beacon_k8s.units
  constraints = var.istio_beacon_k8s.constraints
  config      = var.istio_beacon_k8s.config
}

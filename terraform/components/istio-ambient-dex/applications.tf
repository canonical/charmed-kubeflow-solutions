# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Istio K8s control plane, deployed via the upstream istio-k8s Terraform module
# (track/2 branch, pinned by commit). The upstream module hardcodes trust = true
# and does not accept base/resources, so var.istio_k8s.trust and .resources are
# intentionally not passed.
module "istio_k8s" {
  source = "git::https://github.com/canonical/istio-k8s-operator//terraform?ref=7b1162ba3a9b2af6896545f51e64dd21cc44ee39"

  model_uuid  = var.model_uuid
  app_name    = "istio-k8s"
  channel     = var.istio_k8s.channel
  revision    = var.istio_k8s.revision
  units       = var.istio_k8s.units
  constraints = var.istio_k8s.constraints
  config      = var.istio_k8s.config
}

# Istio Ingress K8s gateway, deployed via the upstream istio-ingress-k8s
# Terraform module (ref pinned to match components/istio-ambient). The upstream
# module hardcodes trust = true and does not accept base/resources, so
# var.istio_ingress_k8s.trust and .resources are intentionally not passed.
module "istio_ingress_k8s" {
  source = "git::https://github.com/canonical/istio-ingress-k8s-operator//terraform?ref=f3c7cd585a5a2a8e36bc750274c48bd5f431051f"

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
  source = "git::https://github.com/canonical/istio-beacon-k8s-operator//terraform?ref=87fbeb0b5ad41b80dc006827293976c3db2bc911"

  model_uuid  = var.model_uuid
  app_name    = "istio-beacon-k8s"
  channel     = var.istio_beacon_k8s.channel
  revision    = var.istio_beacon_k8s.revision
  units       = var.istio_beacon_k8s.units
  constraints = var.istio_beacon_k8s.constraints
  config      = var.istio_beacon_k8s.config
}

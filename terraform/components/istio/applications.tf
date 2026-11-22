# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Deploy a local control plane when no external ingress-config provider is given.
module "istio_k8s" {
  count  = var.istio_ingress_config == null ? 1 : 0
  source = "git::https://github.com/canonical/istio-k8s-operator//terraform?ref=7b1162ba3a9b2af6896545f51e64dd21cc44ee39"

  model_uuid  = var.model_uuid
  app_name    = "istio-k8s"
  channel     = var.istio_k8s.channel
  revision    = var.istio_k8s.revision
  units       = var.istio_k8s.units
  constraints = var.istio_k8s.constraints
  config      = var.istio_k8s.config
}

# Deploy one ingress gateway for each configured role.
module "istio_ingress_k8s" {
  for_each = var.istio_ingress_k8s_gateways
  source   = "git::https://github.com/canonical/service-mesh//charms/istio-ingress-k8s/terraform?ref=7ee9a3d468dbc85ae6e1492de1ba2b83015e8870"

  model_uuid  = var.model_uuid
  app_name    = each.value.app_name
  channel     = var.istio_ingress_k8s.channel
  revision    = var.istio_ingress_k8s.revision
  units       = var.istio_ingress_k8s.units
  constraints = var.istio_ingress_k8s.constraints
  config      = merge(var.istio_ingress_k8s.config, each.value.config)
}

# Beacon provides the in-model service mesh; it joins the Istio control plane
# natively without a Juju relation to istio-k8s.
module "istio_beacon_k8s" {
  source = "git::https://github.com/canonical/service-mesh//charms/istio-beacon-k8s/terraform?ref=7ee9a3d468dbc85ae6e1492de1ba2b83015e8870"

  model_uuid  = var.model_uuid
  app_name    = "istio-beacon-k8s"
  channel     = var.istio_beacon_k8s.channel
  revision    = var.istio_beacon_k8s.revision
  units       = var.istio_beacon_k8s.units
  constraints = var.istio_beacon_k8s.constraints
  config      = var.istio_beacon_k8s.config
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Two Istio ingress gateways: one fronting browser/UI traffic and one fronting
# machine-to-machine (token/JWT) traffic. Each consumes the istio-k8s
# istio-ingress-config offer (typically cross-model from the istio-system model).
module "istio_ingress_k8s_ui" {
  source = "../../charms/istio-ingress-k8s"

  model_uuid  = var.model_uuid
  app_name    = "istio-ingress-k8s-ui"
  channel     = var.istio_ingress_k8s.channel
  revision    = var.istio_ingress_k8s.revision
  units       = var.istio_ingress_k8s.units
  trust       = var.istio_ingress_k8s.trust
  constraints = var.istio_ingress_k8s.constraints
  config      = merge(var.istio_ingress_k8s.config, var.istio_ingress_k8s_ui_config)
  resources   = var.istio_ingress_k8s.resources

  istio_ingress_config = var.istio_ingress_config
}

module "istio_ingress_k8s_m2m" {
  source = "../../charms/istio-ingress-k8s"

  model_uuid  = var.model_uuid
  app_name    = "istio-ingress-k8s-m2m"
  channel     = var.istio_ingress_k8s.channel
  revision    = var.istio_ingress_k8s.revision
  units       = var.istio_ingress_k8s.units
  trust       = var.istio_ingress_k8s.trust
  constraints = var.istio_ingress_k8s.constraints
  config      = merge(var.istio_ingress_k8s.config, var.istio_ingress_k8s_m2m_config)
  resources   = var.istio_ingress_k8s.resources

  istio_ingress_config = var.istio_ingress_config
}

# Beacon: provides the in-model service mesh. It joins the Istio control plane
# natively (no Juju relation to istio-k8s).
module "istio_beacon_k8s" {
  source = "../../charms/istio-beacon-k8s"

  model_uuid  = var.model_uuid
  app_name    = "istio-beacon-k8s"
  channel     = var.istio_beacon_k8s.channel
  revision    = var.istio_beacon_k8s.revision
  units       = var.istio_beacon_k8s.units
  trust       = var.istio_beacon_k8s.trust
  constraints = var.istio_beacon_k8s.constraints
  config      = var.istio_beacon_k8s.config
  resources   = var.istio_beacon_k8s.resources
}

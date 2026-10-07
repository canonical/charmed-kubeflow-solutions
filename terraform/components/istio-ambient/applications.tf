# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Two Istio ingress gateways: one fronting browser/UI traffic and one fronting
# machine-to-machine (token/JWT) traffic. Only the UI gateway consumes the
# istio-k8s istio-ingress-config offer (typically cross-model from the
# istio-system model), for its forward-auth ext-authz config; that integration
# is wired in integrations.tf since the upstream module only deploys the
# application. The M2M gateway is JWT-only and is intentionally not wired to it.
#
module "istio_ingress_k8s_ui" {
  source = "git::https://github.com/canonical/service-mesh//charms/istio-ingress-k8s/terraform?ref=7ee9a3d468dbc85ae6e1492de1ba2b83015e8870"

  model_uuid  = var.model_uuid
  app_name    = "istio-ingress-k8s-ui"
  base        = "ubuntu@26.04"
  channel     = var.istio_ingress_k8s.channel
  revision    = var.istio_ingress_k8s.revision
  units       = var.istio_ingress_k8s.units
  constraints = var.istio_ingress_k8s.constraints
  config      = merge(var.istio_ingress_k8s.config, var.istio_ingress_k8s_ui_config)
}

module "istio_ingress_k8s_m2m" {
  source = "git::https://github.com/canonical/service-mesh//charms/istio-ingress-k8s/terraform?ref=7ee9a3d468dbc85ae6e1492de1ba2b83015e8870"

  model_uuid  = var.model_uuid
  app_name    = "istio-ingress-k8s-m2m"
  base        = "ubuntu@26.04"
  channel     = var.istio_ingress_k8s.channel
  revision    = var.istio_ingress_k8s.revision
  units       = var.istio_ingress_k8s.units
  constraints = var.istio_ingress_k8s.constraints
  config      = merge(var.istio_ingress_k8s.config, var.istio_ingress_k8s_m2m_config)
}

# Beacon: provides the in-model service mesh. It joins the Istio control plane
# natively (no Juju relation to istio-k8s).
#
module "istio_beacon_k8s" {
  source = "git::https://github.com/canonical/service-mesh//charms/istio-beacon-k8s/terraform?ref=7ee9a3d468dbc85ae6e1492de1ba2b83015e8870"

  model_uuid  = var.model_uuid
  app_name    = "istio-beacon-k8s"
  base        = "ubuntu@26.04"
  channel     = var.istio_beacon_k8s.channel
  revision    = var.istio_beacon_k8s.revision
  units       = var.istio_beacon_k8s.units
  constraints = var.istio_beacon_k8s.constraints
  config      = var.istio_beacon_k8s.config
}

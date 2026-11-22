# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# The first gateway consumes either a local istio-k8s endpoint or the external
# endpoint/offer supplied by the caller. Only this gateway uses ext-authz
# forward-auth; the optional second gateway is JWT-only.
resource "juju_integration" "istio_ingress_k8s_ui_config" {
  model_uuid = var.model_uuid

  application {
    name     = module.istio_ingress_k8s_ui["ui"].app_name
    endpoint = "istio-ingress-config"
  }

  application {
    name = var.istio_ingress_config == null ? module.istio_k8s[0].app_name : (
      var.istio_ingress_config.kind == "endpoint" ? var.istio_ingress_config.name : null
    )
    endpoint = var.istio_ingress_config == null ? "istio-ingress-config" : (
      var.istio_ingress_config.kind == "endpoint" ? var.istio_ingress_config.endpoint : null
    )
    offer_url = var.istio_ingress_config != null && var.istio_ingress_config.kind == "offer" ? var.istio_ingress_config.url : null
  }
}

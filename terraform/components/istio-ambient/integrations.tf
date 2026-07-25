# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Gateway -> control plane (istio-ingress-k8s:istio-ingress-config ->
# istio-k8s:istio-ingress-config). Supports a same-model endpoint or a
# cross-model offer (istio-k8s in the istio-system model). The upstream
# istio-ingress-k8s module only deploys the application, so this integration is
# wired here (one per gateway).
#
# The beacon joins the Istio mesh natively, with no Juju relation to the
# control plane. Cross-component wiring (forward-auth, request-auth,
# service-mesh, gateway routing) is performed by the consuming product via this
# component's outputs.
resource "juju_integration" "istio_ingress_k8s_ui_config" {
  count      = var.istio_ingress_config != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = module.istio_ingress_k8s_ui.app_name
    endpoint = "istio-ingress-config"
  }

  application {
    name      = var.istio_ingress_config.kind == "endpoint" ? var.istio_ingress_config.name : null
    endpoint  = var.istio_ingress_config.kind == "endpoint" ? var.istio_ingress_config.endpoint : null
    offer_url = var.istio_ingress_config.kind == "offer" ? var.istio_ingress_config.url : null
  }
}

resource "juju_integration" "istio_ingress_k8s_m2m_config" {
  count      = var.istio_ingress_config != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = module.istio_ingress_k8s_m2m.app_name
    endpoint = "istio-ingress-config"
  }

  application {
    name      = var.istio_ingress_config.kind == "endpoint" ? var.istio_ingress_config.name : null
    endpoint  = var.istio_ingress_config.kind == "endpoint" ? var.istio_ingress_config.endpoint : null
    offer_url = var.istio_ingress_config.kind == "offer" ? var.istio_ingress_config.url : null
  }
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Gateway -> control plane (istio-ingress-k8s:istio-ingress-config ->
# istio-k8s:istio-ingress-config). Supports a same-model endpoint or a
# cross-model offer (istio-k8s in the istio-system model).
resource "juju_integration" "istio_ingress_config" {
  count      = var.istio_ingress_config != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-config"
  }

  application {
    name      = var.istio_ingress_config.kind == "endpoint" ? var.istio_ingress_config.name : null
    endpoint  = var.istio_ingress_config.kind == "endpoint" ? var.istio_ingress_config.endpoint : null
    offer_url = var.istio_ingress_config.kind == "offer" ? var.istio_ingress_config.url : null
  }
}

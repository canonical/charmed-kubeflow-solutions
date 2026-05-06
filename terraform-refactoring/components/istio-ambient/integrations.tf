# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_integration" "istio_k8s_istio_ingress_k8s_ingress_config" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.istio_k8s.name
    endpoint = "istio-ingress-config"
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-config"
  }
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  istio_ingress_config_endpoint = var.istio_ingress_config == null ? {
    kind     = "endpoint"
    name     = module.istio_k8s[0].app_name
    endpoint = "istio-ingress-config"
  } : var.istio_ingress_config
}

resource "juju_integration" "istio_ingress_k8s_config" {
  for_each   = module.istio_ingress_k8s
  model_uuid = var.model_uuid

  application {
    name     = each.value.app_name
    endpoint = "istio-ingress-config"
  }

  application {
    name      = local.istio_ingress_config_endpoint.kind == "endpoint" ? local.istio_ingress_config_endpoint.name : null
    endpoint  = local.istio_ingress_config_endpoint.kind == "endpoint" ? local.istio_ingress_config_endpoint.endpoint : null
    offer_url = local.istio_ingress_config_endpoint.kind == "offer" ? local.istio_ingress_config_endpoint.url : null
  }
}

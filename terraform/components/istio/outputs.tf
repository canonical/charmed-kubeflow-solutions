# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  ingress_k8s_relations = {
    for key, gateway in module.istio_ingress_k8s : key => {
      component = { name = gateway.app_name }
      provides = {
        gateway                 = { name = gateway.app_name, endpoint = "gateway" }
        ingress_unauthenticated = { name = gateway.app_name, endpoint = "ingress-unauthenticated" }
        istio_ingress_route     = { name = gateway.app_name, endpoint = "istio-ingress-route" }
        istio_ingress_route_unauthenticated = {
          name     = gateway.app_name
          endpoint = "istio-ingress-route-unauthenticated"
        }
        gateway_metadata   = { name = gateway.app_name, endpoint = "gateway-metadata" }
        istio_request_auth = { name = gateway.app_name, endpoint = "istio-request-auth" }
        metrics_endpoint   = { name = gateway.app_name, endpoint = "metrics-endpoint" }
      }
      requires = {
        forward_auth = { name = gateway.app_name, endpoint = "forward-auth" }
        certificates = { name = gateway.app_name, endpoint = "certificates" }
      }
    }
  }
}

output "components" {
  description = "Map of the deployed Istio Ambient applications"
  value = {
    istio_k8s = var.istio_ingress_config == null ? {
      name = module.istio_k8s[0].app_name
    } : null
    istio_ingress_k8s = {
      for key, gateway in local.ingress_k8s_relations : key => gateway.component
    }
    istio_beacon_k8s = { name = module.istio_beacon_k8s.app_name }
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    istio_ingress_k8s = {
      for key, gateway in local.ingress_k8s_relations : key => gateway.provides
    }

    istio_beacon_k8s_service_mesh     = { name = module.istio_beacon_k8s.app_name, endpoint = "service-mesh" }
    istio_beacon_k8s_provide_cmr_mesh = { name = module.istio_beacon_k8s.app_name, endpoint = "provide-cmr-mesh" }
    istio_beacon_k8s_metrics_endpoint = { name = module.istio_beacon_k8s.app_name, endpoint = "metrics-endpoint" }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    istio_ingress_k8s = {
      for key, gateway in local.ingress_k8s_relations : key => gateway.requires
    }
  }
}

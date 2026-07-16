# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Istio Ambient applications"
  value = {
    istio_k8s         = { name = module.istio_k8s.app_name }
    istio_ingress_k8s = { name = module.istio_ingress_k8s.app_name }
    istio_beacon_k8s  = { name = module.istio_beacon_k8s.app_name }
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    istio_ingress_k8s_gateway = {
      name     = module.istio_ingress_k8s.app_name
      endpoint = "gateway"
    }
    istio_beacon_k8s_service_mesh = {
      name     = module.istio_beacon_k8s.app_name
      endpoint = "service-mesh"
    }
    istio_ingress_k8s_istio_ingress_route = {
      name     = module.istio_ingress_k8s.app_name
      endpoint = "istio-ingress-route"
    }
    istio_ingress_k8s_istio_ingress_route_unauthenticated = {
      name     = module.istio_ingress_k8s.app_name
      endpoint = "istio-ingress-route-unauthenticated"
    }
    istio_ingress_k8s_gateway_metadata = {
      name     = module.istio_ingress_k8s.app_name
      endpoint = "gateway-metadata"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    istio_ingress_k8s_forward_auth = {
      name     = module.istio_ingress_k8s.app_name
      endpoint = "forward-auth"
    }
  }
}

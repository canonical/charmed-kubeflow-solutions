# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Istio Ambient applications"
  value = {
    istio_k8s         = juju_application.istio_k8s
    istio_ingress_k8s = juju_application.istio_ingress_k8s
    istio_beacon_k8s  = juju_application.istio_beacon_k8s
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    istio_ingress_k8s_gateway = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "gateway"
    }
    istio_beacon_k8s_service_mesh = {
      name     = juju_application.istio_beacon_k8s.name
      endpoint = "service-mesh"
    }
    istio_ingress_k8s_istio_ingress_route = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "istio-ingress-route"
    }
    istio_ingress_k8s_istio_ingress_route_unauthenticated = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "istio-ingress-route-unauthenticated"
    }
    istio_ingress_k8s_gateway_metadata = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "gateway-metadata"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    istio_ingress_k8s_forward_auth = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "forward-auth"
    }
  }
}

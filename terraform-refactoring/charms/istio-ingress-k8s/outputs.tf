# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.istio_ingress_k8s
}

output "provides" {
  description = "Map of provided endpoints."
  value = {
    ingress = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "ingress"
    }
    ingress_unauthenticated = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "ingress-unauthenticated"
    }
    istio_ingress_config = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "istio-ingress-config"
    }
    istio_ingress_route = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "istio-ingress-route"
    }
    istio_ingress_route_unauthenticated = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "istio-ingress-route-unauthenticated"
    }
    gateway_metadata = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "gateway-metadata"
    }
    istio_request_auth = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "istio-request-auth"
    }
    metrics_endpoint = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    certificates = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "certificates"
    }
    forward_auth = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "forward-auth"
    }
    upstream_ingress = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "upstream-ingress"
    }
    charm_tracing = {
      name     = juju_application.istio_ingress_k8s.name
      endpoint = "charm-tracing"
    }
  }
}

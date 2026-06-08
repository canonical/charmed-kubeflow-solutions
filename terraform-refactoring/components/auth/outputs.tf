# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed auth component applications"
  value = {
    dex_auth        = juju_application.dex_auth
    oidc_gatekeeper = juju_application.oidc_gatekeeper
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    oidc_gatekeeper_forward_auth = {
      name     = juju_application.oidc_gatekeeper.name
      endpoint = "forward-auth"
    }
    dex_auth_grafana_dashboard = {
      name     = juju_application.dex_auth.name
      endpoint = "grafana-dashboard"
    }
    dex_auth_metrics_endpoint = {
      name     = juju_application.dex_auth.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    dex_auth_ingress = {
      name     = juju_application.dex_auth.name
      endpoint = "ingress"
    }
    oidc_gatekeeper_ingress = {
      name     = juju_application.oidc_gatekeeper.name
      endpoint = "ingress"
    }
    oidc_gatekeeper_ingress_auth = {
      name     = juju_application.oidc_gatekeeper.name
      endpoint = "ingress-auth"
    }
    dex_auth_service_mesh = {
      name     = juju_application.dex_auth.name
      endpoint = "service-mesh"
    }
    oidc_gatekeeper_service_mesh = {
      name     = juju_application.oidc_gatekeeper.name
      endpoint = "service-mesh"
    }
    oidc_gatekeeper_istio_ingress_route_unauthenticated = {
      name     = juju_application.oidc_gatekeeper.name
      endpoint = "istio-ingress-route-unauthenticated"
    }
    dex_auth_istio_ingress_route_unauthenticated = {
      name     = juju_application.dex_auth.name
      endpoint = "istio-ingress-route-unauthenticated"
    }
    dex_auth_logging = {
      name     = juju_application.dex_auth.name
      endpoint = "logging"
    }
    oidc_gatekeeper_logging = {
      name     = juju_application.oidc_gatekeeper.name
      endpoint = "logging"
    }
  }
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Istio applications"
  value = {
    istio_pilot          = juju_application.istio_pilot
    istio_ingressgateway = juju_application.istio_ingressgateway
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    istio_ingressgateway_gateway = {
      name     = juju_application.istio_ingressgateway.name
      endpoint = "gateway"
    }
    istio_ingressgateway_metrics_endpoint = {
      name     = juju_application.istio_ingressgateway.name
      endpoint = "metrics-endpoint"
    }
    istio_pilot_ingress = {
      name     = juju_application.istio_pilot.name
      endpoint = "ingress"
    }
    istio_pilot_ingress_auth = {
      name     = juju_application.istio_pilot.name
      endpoint = "ingress-auth"
    }
    istio_pilot_metrics_endpoint = {
      name     = juju_application.istio_pilot.name
      endpoint = "metrics-endpoint"
    }
    istio_pilot_grafana_dashboard = {
      name     = juju_application.istio_pilot.name
      endpoint = "grafana-dashboard"
    }
    istio_pilot_gateway_info = {
      name     = juju_application.istio_pilot.name
      endpoint = "gateway-info"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    istio_pilot_certificates = {
      name     = juju_application.istio_pilot.name
      endpoint = "certificates"
    }
  }
}

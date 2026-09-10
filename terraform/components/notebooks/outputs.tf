# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Notebooks applications"
  value = {
    jupyter_controller = juju_application.jupyter_controller
    jupyter_ui         = juju_application.jupyter_ui
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    jupyter_controller_grafana_dashboard = {
      name     = juju_application.jupyter_controller.name
      endpoint = "grafana-dashboard"
    }
    jupyter_controller_metrics_endpoint = {
      name     = juju_application.jupyter_controller.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    jupyter_ui_dashboard_links = {
      name     = juju_application.jupyter_ui.name
      endpoint = "dashboard-links"
    }
    jupyter_ui_ingress = {
      name     = juju_application.jupyter_ui.name
      endpoint = "ingress"
    }
    jupyter_ui_istio_ingress_route = {
      name     = juju_application.jupyter_ui.name
      endpoint = "istio-ingress-route"
    }
    jupyter_controller_gateway_metadata = {
      name     = juju_application.jupyter_controller.name
      endpoint = "gateway-metadata"
    }
    jupyter_controller_logging = {
      name     = juju_application.jupyter_controller.name
      endpoint = "logging"
    }
    jupyter_ui_logging = {
      name     = juju_application.jupyter_ui.name
      endpoint = "logging"
    }
  }
}

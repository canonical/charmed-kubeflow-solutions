# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Notebooks applications"
  value = {
    jupyter_controller = juju_application.jupyter_controller
    jupyter_ui         = juju_application.jupyter_ui
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
  }
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Tensorboard applications"
  value = {
    tensorboard_controller = juju_application.tensorboard_controller
    tensorboards_web_app   = juju_application.tensorboards_web_app
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    tensorboard_controller_metrics_endpoint = {
      name     = juju_application.tensorboard_controller.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    tensorboard_controller_gateway_info = {
      name     = juju_application.tensorboard_controller.name
      endpoint = "gateway-info"
    }
    tensorboard_controller_gateway_metadata = {
      name     = juju_application.tensorboard_controller.name
      endpoint = "gateway-metadata"
    }
    tensorboards_web_app_dashboard_links = {
      name     = juju_application.tensorboards_web_app.name
      endpoint = "dashboard-links"
    }
    tensorboards_web_app_ingress = {
      name     = juju_application.tensorboards_web_app.name
      endpoint = "ingress"
    }
    tensorboards_web_app_istio_ingress_route = {
      name     = juju_application.tensorboards_web_app.name
      endpoint = "istio-ingress-route"
    }
    tensorboard_controller_logging = {
      name     = juju_application.tensorboard_controller.name
      endpoint = "logging"
    }
    tensorboards_web_app_logging = {
      name     = juju_application.tensorboards_web_app.name
      endpoint = "logging"
    }
  }
}

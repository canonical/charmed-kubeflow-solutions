# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Katib applications"
  value = {
    katib_controller = juju_application.katib_controller
    katib_db_manager = juju_application.katib_db_manager
    katib_ui         = juju_application.katib_ui
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    katib_db_manager_relational_db = {
      name     = juju_application.katib_db_manager.name
      endpoint = "relational-db"
    }
    katib_ui_dashboard_links = {
      name     = juju_application.katib_ui.name
      endpoint = "dashboard-links"
    }
    katib_ui_ingress = {
      name     = juju_application.katib_ui.name
      endpoint = "ingress"
    }
    katib_ui_istio_ingress_route = {
      name     = juju_application.katib_ui.name
      endpoint = "istio-ingress-route"
    }
  }
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Feast applications"
  value = {
    feast_integrator = juju_application.feast_integrator
    feast_ui         = juju_application.feast_ui
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    feast_integrator_feast_configuration = {
      name     = juju_application.feast_integrator.name
      endpoint = "feast-configuration"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    feast_integrator_offline_store = {
      name     = juju_application.feast_integrator.name
      endpoint = "offline-store"
    }
    feast_integrator_online_store = {
      name     = juju_application.feast_integrator.name
      endpoint = "online-store"
    }
    feast_integrator_registry = {
      name     = juju_application.feast_integrator.name
      endpoint = "registry"
    }
    feast_integrator_secrets = {
      name     = juju_application.feast_integrator.name
      endpoint = "secrets"
    }
    feast_integrator_pod_defaults = {
      name     = juju_application.feast_integrator.name
      endpoint = "pod-defaults"
    }
    feast_ui_dashboard_links = {
      name     = juju_application.feast_ui.name
      endpoint = "dashboard-links"
    }
    feast_ui_ingress = {
      name     = juju_application.feast_ui.name
      endpoint = "ingress"
    }
  }
}

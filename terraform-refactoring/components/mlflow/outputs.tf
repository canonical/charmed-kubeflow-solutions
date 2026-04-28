# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed MLflow applications"
  value = {
    mlflow_server = juju_application.mlflow_server
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    mlflow_server_dashboard_links = {
      name     = juju_application.mlflow_server.name
      endpoint = "dashboard-links"
    }
    mlflow_server_relational_db = {
      name     = juju_application.mlflow_server.name
      endpoint = "relational-db"
    }
    mlflow_server_object_storage = {
      name     = juju_application.mlflow_server.name
      endpoint = "object-storage"
    }
    mlflow_server_ingress = {
      name     = juju_application.mlflow_server.name
      endpoint = "ingress"
    }
    mlflow_server_istio_ingress_route = {
      name     = juju_application.mlflow_server.name
      endpoint = "istio-ingress-route"
    }
    mlflow_server_service_mesh = {
      name     = juju_application.mlflow_server.name
      endpoint = "service-mesh"
    }
    mlflow_server_secrets = {
      name     = juju_application.mlflow_server.name
      endpoint = "secrets"
    }
    mlflow_server_pod_defaults = {
      name     = juju_application.mlflow_server.name
      endpoint = "pod-defaults"
    }
  }
}

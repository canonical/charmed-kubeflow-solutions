# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.minio
}

output "provides" {
  description = "Map of provided endpoints."
  value = {
    object_storage = {
      name     = juju_application.minio.name
      endpoint = "object-storage"
    }
    grafana_dashboard = {
      name     = juju_application.minio.name
      endpoint = "grafana-dashboard"
    }
    metrics_endpoint = {
      name     = juju_application.minio.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    service_mesh = {
      name     = juju_application.minio.name
      endpoint = "service-mesh"
    }
  }
}

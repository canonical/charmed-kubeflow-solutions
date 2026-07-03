# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.istio_beacon_k8s
}

output "provides" {
  description = "Map of provided endpoints."
  value = {
    service_mesh = {
      name     = juju_application.istio_beacon_k8s.name
      endpoint = "service-mesh"
    }
    provide_cmr_mesh = {
      name     = juju_application.istio_beacon_k8s.name
      endpoint = "provide-cmr-mesh"
    }
    metrics_endpoint = {
      name     = juju_application.istio_beacon_k8s.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    charm_tracing = {
      name     = juju_application.istio_beacon_k8s.name
      endpoint = "charm-tracing"
    }
  }
}

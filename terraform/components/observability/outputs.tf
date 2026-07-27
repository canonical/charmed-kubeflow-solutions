# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed observability component applications"
  value = {
    opentelemetry_collector_k8s = juju_application.opentelemetry_collector_k8s
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    opentelemetry_collector_k8s_grafana_dashboards_provider = {
      name     = juju_application.opentelemetry_collector_k8s.name
      endpoint = "grafana-dashboards-provider"
    }
    opentelemetry_collector_k8s_send_remote_write = {
      name     = juju_application.opentelemetry_collector_k8s.name
      endpoint = "send-remote-write"
    }
    opentelemetry_collector_k8s_loki_push = {
      name     = juju_application.opentelemetry_collector_k8s.name
      endpoint = "send-loki-logs"
    }
  }
}

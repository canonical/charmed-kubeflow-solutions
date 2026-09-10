# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Training applications"
  value = merge(
    var.enable_v1 ? {
      training_operator = juju_application.training_operator[0]
    } : {},
    var.enable_v2 ? {
      kubeflow_trainer = juju_application.kubeflow_trainer[0]
    } : {}
  )
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = merge(
    var.enable_v1 ? {
      training_operator_grafana_dashboard = {
        name     = juju_application.training_operator[0].name
        endpoint = "grafana-dashboard"
      }
      training_operator_metrics_endpoint = {
        name     = juju_application.training_operator[0].name
        endpoint = "metrics-endpoint"
      }
    } : {},
    var.enable_v2 ? {
      kubeflow_trainer_grafana_dashboard = {
        name     = juju_application.kubeflow_trainer[0].name
        endpoint = "grafana-dashboard"
      }
      kubeflow_trainer_metrics_endpoint = {
        name     = juju_application.kubeflow_trainer[0].name
        endpoint = "metrics-endpoint"
      }
    } : {}
  )
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = merge(
    var.enable_v1 ? {
      training_operator_dashboard_links = {
        name     = juju_application.training_operator[0].name
        endpoint = "dashboard-links"
      }
    } : {},
    var.enable_v2 ? {
      kubeflow_trainer_dashboard_links = {
        name     = juju_application.kubeflow_trainer[0].name
        endpoint = "dashboard-links"
      }
    } : {}
  )
}

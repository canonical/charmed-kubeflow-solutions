# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Training applications"
  value = merge(
    {
      training_operator = juju_application.training_operator
    },
    var.enable_v2 ? {
      kubeflow_trainer = juju_application.kubeflow_trainer[0]
    } : {}
  )
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = merge(
    {
      training_operator_dashboard_links = {
        name     = juju_application.training_operator.name
        endpoint = "dashboard-links"
      }
    },
    var.enable_v2 ? {
      kubeflow_trainer_dashboard_links = {
        name     = juju_application.kubeflow_trainer[0].name
        endpoint = "dashboard-links"
      }
    } : {}
  )
}

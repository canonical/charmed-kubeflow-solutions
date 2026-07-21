# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.integrator
}

output "app_name" {
  description = "Name of the deployed data-kubeflow integrator."
  value       = juju_application.integrator.name
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    secrets = {
      name     = juju_application.integrator.name
      endpoint = "secrets"
    }
    pod_defaults = {
      name     = juju_application.integrator.name
      endpoint = "pod-defaults"
    }
    service_accounts = {
      name     = juju_application.integrator.name
      endpoint = "service-accounts"
    }
    roles = {
      name     = juju_application.integrator.name
      endpoint = "roles"
    }
    role_bindings = {
      name     = juju_application.integrator.name
      endpoint = "role-bindings"
    }
  }
}

output "provides" {
  description = "Map of provided endpoints."
  value       = {}
}

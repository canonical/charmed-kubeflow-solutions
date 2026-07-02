# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.resource_dispatcher
}

output "app_name" {
  description = "Name of the deployed resource-dispatcher application."
  value       = juju_application.resource_dispatcher.name
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    service_mesh = {
      name     = juju_application.resource_dispatcher.name
      endpoint = "service-mesh"
    }
  }
}

output "provides" {
  description = "Map of provided endpoints."
  value = {
    secrets = {
      name     = juju_application.resource_dispatcher.name
      endpoint = "secrets"
    }
    pod_defaults = {
      name     = juju_application.resource_dispatcher.name
      endpoint = "pod-defaults"
    }
    roles = {
      name     = juju_application.resource_dispatcher.name
      endpoint = "roles"
    }
    role_bindings = {
      name     = juju_application.resource_dispatcher.name
      endpoint = "role-bindings"
    }
    service_accounts = {
      name     = juju_application.resource_dispatcher.name
      endpoint = "service-accounts"
    }
  }
}

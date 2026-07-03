# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.github_profiles_automator
}

output "provides" {
  description = "Map of provided endpoints."
  value = {
    provide_cmr_mesh = {
      name     = juju_application.github_profiles_automator.name
      endpoint = "provide-cmr-mesh"
    }
  }
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    service_mesh = {
      name     = juju_application.github_profiles_automator.name
      endpoint = "service-mesh"
    }
    require_cmr_mesh = {
      name     = juju_application.github_profiles_automator.name
      endpoint = "require-cmr-mesh"
    }
  }
}

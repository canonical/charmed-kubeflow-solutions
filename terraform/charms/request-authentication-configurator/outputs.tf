# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.request_authentication_configurator
}

output "provides" {
  description = "Map of provided endpoints."
  value       = {}
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    oauth = {
      name     = juju_application.request_authentication_configurator.name
      endpoint = "oauth"
    }
    # One RequestAuthentication CR per gateway (interface: istio_request_auth).
    request_auth_m2m = {
      name     = juju_application.request_authentication_configurator.name
      endpoint = "request-auth-m2m"
    }
    request_auth_ui = {
      name     = juju_application.request_authentication_configurator.name
      endpoint = "request-auth-ui"
    }
  }
}

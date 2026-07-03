# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.oauth2_proxy
}

output "provides" {
  description = "Map of provided endpoints."
  value = {
    auth_proxy = {
      name     = juju_application.oauth2_proxy.name
      endpoint = "auth-proxy"
    }
    forward_auth = {
      name     = juju_application.oauth2_proxy.name
      endpoint = "forward-auth"
    }
  }
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    ingress = {
      name     = juju_application.oauth2_proxy.name
      endpoint = "ingress"
    }
    oauth = {
      name     = juju_application.oauth2_proxy.name
      endpoint = "oauth"
    }
    receive_ca_cert = {
      name     = juju_application.oauth2_proxy.name
      endpoint = "receive-ca-cert"
    }
  }
}

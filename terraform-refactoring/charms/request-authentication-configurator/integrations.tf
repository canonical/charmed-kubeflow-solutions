# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# request-authentication-configurator -> hydra
# (request-authentication-configurator:oauth -> hydra:oauth). Supports a
# same-model endpoint or a cross-model offer (Hydra in the iam model).
resource "juju_integration" "oauth" {
  count      = var.oauth != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.request_authentication_configurator.name
    endpoint = "oauth"
  }

  application {
    name      = var.oauth.kind == "endpoint" ? var.oauth.name : null
    endpoint  = var.oauth.kind == "endpoint" ? var.oauth.endpoint : null
    offer_url = var.oauth.kind == "offer" ? var.oauth.url : null
  }
}

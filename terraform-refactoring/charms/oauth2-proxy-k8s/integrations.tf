# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# oauth2-proxy -> hydra (oauth2-proxy:oauth -> hydra:oauth). Supports a
# same-model endpoint or a cross-model offer (Hydra in the iam model).
resource "juju_integration" "oauth" {
  count      = var.oauth != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.oauth2_proxy.name
    endpoint = "oauth"
  }

  application {
    name      = var.oauth.kind == "endpoint" ? var.oauth.name : null
    endpoint  = var.oauth.kind == "endpoint" ? var.oauth.endpoint : null
    offer_url = var.oauth.kind == "offer" ? var.oauth.url : null
  }
}

# oauth2-proxy -> CA certificate provider (oauth2-proxy:receive-ca-cert ->
# provider:send-ca-cert). Supports a same-model endpoint or a cross-model offer
# (send-ca-cert offer from the iam-core model) so oauth2-proxy trusts the
# self-signed CA fronting the Identity Platform.
resource "juju_integration" "receive_ca_cert" {
  count      = var.ca_cert != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.oauth2_proxy.name
    endpoint = "receive-ca-cert"
  }

  application {
    name      = var.ca_cert.kind == "endpoint" ? var.ca_cert.name : null
    endpoint  = var.ca_cert.kind == "endpoint" ? var.ca_cert.endpoint : null
    offer_url = var.ca_cert.kind == "offer" ? var.ca_cert.url : null
  }
}

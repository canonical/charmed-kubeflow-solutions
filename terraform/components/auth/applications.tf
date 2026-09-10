# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Dex Auth application (OIDC provider)
resource "juju_application" "dex_auth" {
  charm {
    name     = "dex-auth"
    channel  = var.dex_auth.channel
    revision = var.dex_auth.revision
  }

  model_uuid  = var.model_uuid
  name        = "dex-auth"
  units       = var.dex_auth.units
  trust       = var.dex_auth.trust
  constraints = var.dex_auth.constraints
  config      = var.dex_auth.config
  resources   = var.dex_auth.resources
}

# OIDC Gatekeeper application (auth gateway)
resource "juju_application" "oidc_gatekeeper" {
  charm {
    name     = "oidc-gatekeeper"
    channel  = var.oidc_gatekeeper.channel
    revision = var.oidc_gatekeeper.revision
  }

  model_uuid  = var.model_uuid
  name        = "oidc-gatekeeper"
  units       = var.oidc_gatekeeper.units
  trust       = var.oidc_gatekeeper.trust
  constraints = var.oidc_gatekeeper.constraints
  config      = var.oidc_gatekeeper.config
  resources   = var.oidc_gatekeeper.resources
}

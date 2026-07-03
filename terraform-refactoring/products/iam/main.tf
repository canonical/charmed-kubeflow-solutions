# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "iam" {
  count = var.create_model ? 1 : 0
  name  = var.model_name
}

locals {
  model_uuid = var.create_model ? juju_model.iam[0].uuid : var.model_uuid
}

# --- Dependencies deployed in the iam model ---------------------------------

module "postgresql_k8s" {
  source = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=b7822d93f8d5d0d94ca3da36ea9f5b13f3e58d43"

  model_uuid = local.model_uuid
  app_name   = "postgresql-k8s"
  channel    = var.postgresql_k8s_channel
  revision   = var.postgresql_k8s_revision
  config     = var.postgresql_k8s_config
  storage_directives = {
    pgdata = var.storage_size
  }
}

resource "juju_application" "traefik" {
  name       = "traefik"
  model_uuid = local.model_uuid

  charm {
    name     = "traefik-k8s"
    channel  = var.traefik_channel
    revision = var.traefik_revision
    base     = "ubuntu@24.04"
  }

  config = var.traefik_config
  trust  = true
  units  = 1
}

resource "juju_application" "self_signed_certificates" {
  name       = "self-signed-certificates"
  model_uuid = local.model_uuid

  charm {
    name     = "self-signed-certificates"
    channel  = var.self_signed_certificates_channel
    revision = var.self_signed_certificates_revision
    base     = "ubuntu@24.04"
  }

  config = var.self_signed_certificates_config
  trust  = true
  units  = 1
}

# traefik TLS termination via self-signed-certificates
resource "juju_integration" "traefik_certificates" {
  model_uuid = local.model_uuid

  application {
    name     = juju_application.traefik.name
    endpoint = "certificates"
  }

  application {
    name     = juju_application.self_signed_certificates.name
    endpoint = "certificates"
  }
}

# --- Same-model offers consumed by the iam-bundle module --------------------
# The iam-bundle-integration module consumes its dependencies via offer URLs
# (it reads the model through data.juju_model.this). We therefore expose the
# in-model dependencies as offers and feed their URLs back into the module.

resource "juju_offer" "postgresql" {
  name             = "postgresql"
  application_name = module.postgresql_k8s.app_name
  endpoints        = ["database"]
  model_uuid       = local.model_uuid
}

resource "juju_offer" "traefik_route" {
  name             = "traefik-route"
  application_name = juju_application.traefik.name
  endpoints        = ["traefik-route"]
  model_uuid       = local.model_uuid
}

# --- Identity Platform bundle (hydra / kratos / login-ui) -------------------

module "iam_bundle" {
  source = "../../vendor/iam-bundle-integration"

  model = local.model_uuid

  postgresql_offer_url    = juju_offer.postgresql.url
  traefik_route_offer_url = juju_offer.traefik_route.url

  enable_kratos_external_idp_integrator = var.enable_kratos_external_idp_integrator
  kratos_external_idp_integrator        = var.kratos_external_idp_integrator

  hydra    = var.hydra
  kratos   = var.kratos
  login_ui = var.login_ui
}

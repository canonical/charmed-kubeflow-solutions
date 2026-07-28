# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "iam" {
  count = var.create_model ? 1 : 0
  name  = var.model_name
}

# IAM Core (postgresql-k8s / traefik-k8s / self-signed-certificates) live in
# a separate model and are wired into the iam model via cross-model offers.
resource "juju_model" "iam_core" {
  count = var.create_model ? 1 : 0
  name  = var.iam_core_model_name
}

locals {
  model_uuid          = var.create_model ? juju_model.iam[0].uuid : var.model_uuid
  iam_core_model_uuid = var.create_model ? juju_model.iam_core[0].uuid : var.iam_core_model_uuid

  # App names of the bundle-deployed apps, derived exactly as the vendored
  # iam-bundle-integration module derives them (var.<app>.name with these
  # defaults). Kept here so the CA-cert relations can target them without
  # modifying the vendored module.
  kratos_app_name   = try(var.kratos.name, "kratos")
  login_ui_app_name = try(var.login_ui.name, "login-ui")
}

# --- IAM Core deployed in the iam-core model --------------------

module "postgresql_k8s" {
  source = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=b7822d93f8d5d0d94ca3da36ea9f5b13f3e58d43"

  model_uuid = local.iam_core_model_uuid
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
  model_uuid = local.iam_core_model_uuid

  charm {
    name     = "traefik-k8s"
    channel  = var.traefik_channel
    revision = var.traefik_revision
    base     = "ubuntu@20.04"
  }

  config = var.traefik_config
  trust  = true
  units  = 1
}

resource "juju_application" "self_signed_certificates" {
  name       = "self-signed-certificates"
  model_uuid = local.iam_core_model_uuid

  charm {
    name     = "self-signed-certificates"
    channel  = var.self_signed_certificates_channel
    revision = var.self_signed_certificates_revision
    base     = "ubuntu@22.04"
  }

  config = var.self_signed_certificates_config
  trust  = true
  units  = 1
}

# traefik TLS termination via self-signed-certificates (iam-core model)
resource "juju_integration" "traefik_certificates" {
  model_uuid = local.iam_core_model_uuid

  application {
    name     = juju_application.traefik.name
    endpoint = "certificates"
  }

  application {
    name     = juju_application.self_signed_certificates.name
    endpoint = "certificates"
  }
}

# --- Cross-model offers from the iam-core model ---------------------
# The iam-bundle (iam model) consumes postgresql/traefik-route via offer URLs,
# and the Identity Platform apps trust the self-signed CA via the send-ca-cert
# offer.

resource "juju_offer" "postgresql" {
  name             = "postgresql"
  application_name = module.postgresql_k8s.app_name
  endpoints        = ["database"]
  model_uuid       = local.iam_core_model_uuid
}

resource "juju_offer" "traefik_route" {
  name             = "traefik-route"
  application_name = juju_application.traefik.name
  endpoints        = ["traefik-route"]
  model_uuid       = local.iam_core_model_uuid
}

resource "juju_offer" "send_ca_cert" {
  name             = "send-ca-cert"
  application_name = juju_application.self_signed_certificates.name
  endpoints        = ["send-ca-cert"]
  model_uuid       = local.iam_core_model_uuid
}

# --- Identity Platform bundle (hydra / kratos / login-ui) -------------------

module "iam_bundle" {
  source = "../../vendor/iam-bundle-integration"

  model = local.model_uuid

  postgresql_offer_url    = juju_offer.postgresql.url
  traefik_route_offer_url = juju_offer.traefik_route.url

  enable_kratos_external_idp_integrator = var.enable_kratos_external_idp_integrator
  kratos_external_idp_integrator        = var.kratos_external_idp_integrator

  hydra = merge({ channel = "latest/stable" }, var.hydra, var.hydra_revision != null ? { revision = var.hydra_revision } : {})
  kratos = merge({ channel = "latest/stable" }, var.kratos, {
    # Product-level default Kratos config (overridable via var.kratos.config).
    config = merge({
      dev         = "true"
      enforce_mfa = "false"
    }, try(var.kratos.config, {}))
  }, var.kratos_revision != null ? { revision = var.kratos_revision } : {})
  login_ui = merge({ channel = "latest/stable" }, var.login_ui, var.login_ui_revision != null ? { revision = var.login_ui_revision } : {})
}

# --- CA-cert trust (cross-model: iam-core -> iam) -------------------
# Kratos and the Login UI trust the self-signed CA (which terminates TLS on
# traefik) by consuming the send-ca-cert offer from the iam-core model.
resource "juju_integration" "kratos_receive_ca_cert" {
  depends_on = [module.iam_bundle]
  model_uuid = local.model_uuid

  application {
    name     = local.kratos_app_name
    endpoint = "receive-ca-cert"
  }

  application {
    offer_url = juju_offer.send_ca_cert.url
  }
}

resource "juju_integration" "login_ui_receive_ca_cert" {
  depends_on = [module.iam_bundle]
  model_uuid = local.model_uuid

  application {
    name     = local.login_ui_app_name
    endpoint = "receive-ca-cert"
  }

  application {
    offer_url = juju_offer.send_ca_cert.url
  }
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# ===========================================================================
# istio-system model: Istio ambient control plane (istio-k8s).
# The control plane is deployed in its own model and its istio-ingress-config
# endpoint is offered cross-model so the gateways in the mlflow model can
# attach to it.
# ===========================================================================

resource "juju_model" "istio_system" {
  count = var.create_istio_system_model ? 1 : 0
  name  = var.istio_system_model_name
}

locals {
  istio_system_model_uuid = var.create_istio_system_model ? juju_model.istio_system[0].uuid : var.istio_system_model_uuid

  # Merge the top-level external hostname vars into the per-component config
  # maps (only when set, so an unset hostname never injects an empty value).
  istio_ingress_k8s_ui_config = merge(
    var.istio_ingress_k8s_ui_config,
    var.external_ui_hostname != null ? { external_hostname = var.external_ui_hostname } : {}
  )
  istio_ingress_k8s_m2m_config = merge(
    var.istio_ingress_k8s_m2m_config,
    var.external_m2m_hostname != null ? { external_hostname = var.external_m2m_hostname } : {}
  )
  traefik_config = merge(
    var.traefik_config,
    var.external_auth_hostname != null ? { external_hostname = var.external_auth_hostname } : {}
  )
}

module "istio_k8s" {
  source = "git::https://github.com/canonical/service-mesh//charms/istio-k8s/terraform?ref=7ee9a3d468dbc85ae6e1492de1ba2b83015e8870"

  model_uuid = local.istio_system_model_uuid
  app_name   = "istio-k8s"
  base       = var.use_old_istio_bases ? "ubuntu@24.04" : "ubuntu@26.04"
  channel    = var.istio_k8s_channel
  revision   = var.istio_k8s_revision
  config     = merge(var.istio_k8s_config, { platform = var.istio_k8s_platform })
}

resource "juju_offer" "istio_ingress_config" {
  name             = "istio-ingress-config"
  application_name = module.istio_k8s.app_name
  endpoints        = [module.istio_k8s.requires.istio_ingress_config]
  model_uuid       = local.istio_system_model_uuid
}

# istio-k8s trusts the self-signed CA (used for the JWKS TLS endpoint in the iam
# model) by consuming the iam-core send-ca-cert offer via jwks-ca-cert.
resource "juju_integration" "istio_k8s_jwks_ca_cert" {
  model_uuid = local.istio_system_model_uuid

  application {
    # The upstream istio-k8s module does not surface jwks-ca-cert in its
    # requires output, so the endpoint is referenced literally.
    name     = module.istio_k8s.app_name
    endpoint = "jwks-ca-cert"
  }

  application {
    offer_url = module.iam.send_ca_cert_offer_url
  }
}

# ===========================================================================
# iam model: Canonical Identity Platform (Hydra / Kratos / Login UI).
# Exposes oauth_offer_url (Hydra oauth), consumed cross-model by oauth2-proxy
# and request-authentication-configurator in the mlflow model.
# ===========================================================================

module "iam" {
  source = "../../products/iam"

  create_model = var.create_iam_model
  model_name   = var.iam_model_name
  model_uuid   = var.iam_model_uuid

  enable_kratos_external_idp_integrator = var.enable_kratos_external_idp_integrator
  kratos_external_idp_integrator        = var.kratos_external_idp_integrator

  hydra_revision    = var.hydra_revision
  kratos_revision   = var.kratos_revision
  login_ui_revision = var.login_ui_revision

  traefik_config = local.traefik_config
}

# ===========================================================================
# MLflow model: MLflow application + the two ambient gateways + beacon +
# the IAM auth stack. Consumes the istio-system and iam offers cross-model.
# ===========================================================================

module "mlflow" {
  source = "../../products/mlflow"

  release      = var.release
  risk         = var.risk
  create_model = var.create_model
  model_uuid   = var.model_uuid

  use_old_istio_bases = var.use_old_istio_bases

  # Cross-model wiring
  istio_ingress_config_offer_url = juju_offer.istio_ingress_config.url
  oauth_offer_url                = module.iam.oauth_offer_url
  send_ca_cert_offer_url         = module.iam.send_ca_cert_offer_url

  # Per-gateway configuration (e.g. external_hostname)
  istio_ingress_k8s_ui_config  = local.istio_ingress_k8s_ui_config
  istio_ingress_k8s_m2m_config = local.istio_ingress_k8s_m2m_config

  s3_bucket_global     = var.s3_bucket_global
  s3_access_key_global = var.s3_access_key_global
  s3_secret_key_global = var.s3_secret_key_global
  s3_endpoint_global   = var.s3_endpoint_global

  enable_observability = var.enable_observability
  dashboards_offer     = var.dashboards_offer
  logging_offer        = var.logging_offer
  metrics_offer        = var.metrics_offer

  user_grants_across_workspaces = var.user_grants_across_workspaces
}

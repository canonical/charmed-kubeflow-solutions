# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# ===========================================================================
# istio-system model: Istio ambient control plane (istio-k8s).
# The control plane is deployed in its own model and its istio-ingress-config
# endpoint is offered cross-model so the gateways in the kubeflow model can
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
  kserve_controller_config = merge(
    var.kserve_controller_config,
    var.external_m2m_hostname != null ? { "domain-name" = var.external_m2m_hostname } : {}
  )
  traefik_config = merge(
    var.traefik_config,
    var.external_auth_hostname != null ? { external_hostname = var.external_auth_hostname } : {}
  )
}

module "istio_k8s" {
  source = "../../charms/istio-k8s"

  model_uuid = local.istio_system_model_uuid
  channel    = var.istio_k8s_channel
  revision   = var.istio_k8s_revision
  config     = merge(var.istio_k8s_config, { platform = var.istio_k8s_platform })
}

resource "juju_offer" "istio_ingress_config" {
  name             = "istio-ingress-config"
  application_name = module.istio_k8s.requires.istio_ingress_config.name
  endpoints        = [module.istio_k8s.requires.istio_ingress_config.endpoint]
  model_uuid       = local.istio_system_model_uuid
}

# istio-k8s trusts the self-signed CA (used for the JWKS TLS endpoint in the iam
# model) by consuming the iam-core send-ca-cert offer via jwks-ca-cert.
resource "juju_integration" "istio_k8s_jwks_ca_cert" {
  model_uuid = local.istio_system_model_uuid

  application {
    name     = module.istio_k8s.requires.jwks_ca_cert.name
    endpoint = module.istio_k8s.requires.jwks_ca_cert.endpoint
  }

  application {
    offer_url = module.iam.send_ca_cert_offer_url
  }
}

# ===========================================================================
# iam model: Canonical Identity Platform (Hydra / Kratos / Login UI).
# Exposes oauth_offer_url (Hydra oauth), consumed cross-model by oauth2-proxy
# and request-authentication-configurator in the kubeflow model.
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
# kubeflow model: Kubeflow applications + the two ambient gateways + beacon +
# the IAM auth stack. Consumes the istio-system and iam offers cross-model.
# ===========================================================================

module "kubeflow" {
  source = "../../products/kubeflow"

  release           = var.release
  risk              = var.risk
  create_model      = var.create_model
  model_uuid        = var.model_uuid
  service_mesh_type = "ambient-iam"

  # Cross-model wiring
  istio_ingress_config_offer_url = juju_offer.istio_ingress_config.url
  oauth_offer_url                = module.iam.oauth_offer_url
  send_ca_cert_offer_url         = module.iam.send_ca_cert_offer_url

  # Per-gateway configuration (e.g. external_hostname)
  istio_ingress_k8s_ui_config  = local.istio_ingress_k8s_ui_config
  istio_ingress_k8s_m2m_config = local.istio_ingress_k8s_m2m_config

  enable_kfp         = var.enable_kfp
  enable_katib       = var.enable_katib
  enable_notebooks   = var.enable_notebooks
  enable_tensorboard = var.enable_tensorboard
  enable_training_v1 = var.enable_training_v1
  enable_training_v2 = var.enable_training_v2
  enable_mlflow      = var.enable_mlflow
  enable_kserve      = var.enable_kserve
  enable_feast       = var.enable_feast

  kserve_controller_config = local.kserve_controller_config

  github_profiles_automator_config = var.github_profiles_automator_config

  enable_observability = var.enable_observability
  dashboards_offer     = var.dashboards_offer
  logging_offer        = var.logging_offer
  metrics_offer        = var.metrics_offer
}

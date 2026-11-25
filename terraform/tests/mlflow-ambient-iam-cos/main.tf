# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# ===========================================================================
# cos model: COS Lite observability stack. Its Grafana dashboards, Loki
# logging and Prometheus remote-write offers are consumed cross-model by the
# opentelemetry-collector-k8s deployed in the mlflow model.
# ===========================================================================

resource "juju_model" "cos" {
  count = var.create_cos_model ? 1 : 0
  name  = var.cos_model_name
}

locals {
  cos_model_uuid = var.create_cos_model ? juju_model.cos[0].uuid : var.cos_model_uuid
}

module "cos" {
  source = "git::https://github.com/canonical/observability-stack//terraform/cos-lite?ref=04ab6c618dbbec62292a052a61cdb402d80e5974"

  model_uuid   = local.cos_model_uuid
  channel      = var.cos_channel
  internal_tls = false
}

# ===========================================================================
# MLflow with ambient mesh + Canonical Identity Platform (istio-system, iam,
# iam-core and mlflow models), with observability wired to COS Lite.
# ===========================================================================

module "mlflow_ambient_iam" {
  source = "../mlflow-ambient-iam"

  # istio-system
  create_istio_system_model = var.create_istio_system_model
  istio_system_model_name   = var.istio_system_model_name
  istio_system_model_uuid   = var.istio_system_model_uuid
  istio_k8s_channel         = var.istio_k8s_channel
  istio_k8s_platform        = var.istio_k8s_platform

  # External hostnames
  external_ui_hostname   = var.external_ui_hostname
  external_m2m_hostname  = var.external_m2m_hostname
  external_auth_hostname = var.external_auth_hostname

  # iam
  create_iam_model = var.create_iam_model
  iam_model_name   = var.iam_model_name
  iam_model_uuid   = var.iam_model_uuid

  # mlflow
  release      = var.release
  risk         = var.risk
  create_model = var.create_model
  model_uuid   = var.model_uuid

  s3_bucket_global     = var.s3_bucket_global
  s3_access_key_global = var.s3_access_key_global
  s3_secret_key_global = var.s3_secret_key_global
  s3_endpoint_global   = var.s3_endpoint_global

  user_grants_across_workspaces = var.user_grants_across_workspaces

  # Observability is always enabled in mlflow-ambient-iam-cos and automatically wired to COS
  enable_observability = true
  dashboards_offer     = module.cos.offers.grafana_dashboards.url
  logging_offer        = module.cos.offers.loki_logging.url
  metrics_offer        = module.cos.offers.prometheus_receive_remote_write.url
}

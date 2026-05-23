# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "cos" {
  count = var.create_cos_model ? 1 : 0
  name  = var.cos_model_name
}

module "cos" {
  source = "git::https://github.com/canonical/observability-stack//terraform/cos-lite?ref=04ab6c618dbbec62292a052a61cdb402d80e5974"

  model_uuid   = var.create_cos_model ? juju_model.cos[0].uuid : var.cos_model_uuid
  channel      = var.cos_channel
  internal_tls = false
}

resource "juju_model" "database" {
  count = var.create_db_model ? 1 : 0
  name  = var.db_model_name
}

module "postgresql" {
  source = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=b7822d93f8d5d0d94ca3da36ea9f5b13f3e58d43"

  model_uuid = var.create_db_model ? juju_model.database[0].uuid : var.db_model_uuid
  app_name   = "general-db"
  channel    = "14/stable"
}

resource "juju_offer" "postgresql" {
  model_uuid = var.create_db_model ? juju_model.database[0].uuid : var.db_model_uuid
  application_name = module.postgresql.app_name
  endpoints        = ["database"]
}

module "kubeflow" {
  source = "../../products/kubeflow"

  release            = var.release
  risk               = var.risk
  create_model       = var.create_model
  model_uuid         = var.model_uuid
  service_mesh_type  = var.service_mesh_type
  istio_k8s_platform = var.istio_k8s_platform

  enable_kfp         = false
  enable_katib       = false
  enable_notebooks   = true
  enable_tensorboard = false
  enable_training_v1 = false
  enable_training_v2 = false
  enable_mlflow      = true
  enable_kserve      = true
  enable_feast       = false

  # Observability is always enabled in kubeflow-cos and automatically wired to COS
  enable_observability = true
  dashboards_offer     = module.cos.offers.grafana_dashboards.url
  logging_offer        = module.cos.offers.loki_logging.url
  metrics_offer        = module.cos.offers.prometheus_receive_remote_write.url

  # External integrations
  integrations = {
    general = {
      profile = "*"
      postgresql = {
        database_name = "general"
        kind = "offer"
        url = juju_offer.postgresql.url
      }
    }
  }
}

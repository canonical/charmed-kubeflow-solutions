# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "cos" {
  count = var.create_cos_model ? 1 : 0
  name  = var.cos_model_name
}

module "cos" {
  source = "git::https://github.com/canonical/observability-stack//terraform/cos-lite?ref=04ab6c618dbbec62292a052a61cdb402d80e5974"

  model_uuid = var.create_cos_model ? juju_model.cos[0].uuid : var.cos_model_uuid
  channel    = var.cos_channel
}

module "kubeflow" {
  source = "../../products/kubeflow"

  release            = var.release
  risk               = var.risk
  create_model       = var.create_model
  model_uuid         = var.model_uuid
  service_mesh_type  = var.service_mesh_type
  istio_k8s_platform = var.istio_k8s_platform

  mysql          = var.mysql
  postgresql_k8s = var.postgresql_k8s

  enable_kfp         = var.enable_kfp
  enable_katib       = var.enable_katib
  enable_notebooks   = var.enable_notebooks
  enable_tensorboard = var.enable_tensorboard
  enable_training_v1 = var.enable_training_v1
  enable_training_v2 = var.enable_training_v2
  enable_mlflow      = var.enable_mlflow
  enable_kserve      = var.enable_kserve
  enable_feast       = var.enable_feast

  # Observability is always enabled in kubeflow-cos and automatically wired to COS
  enable_observability        = true
  dashboards_offer            = module.cos.offers.grafana_dashboards.url
  logging_offer               = module.cos.offers.loki_logging.url
  metrics_offer               = module.cos.offers.prometheus_receive_remote_write.url
  opentelemetry_collector_k8s = var.opentelemetry_collector_k8s
}

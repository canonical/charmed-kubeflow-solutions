# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# resource "juju_model" "cos" {
#   name  = var.cos_model_name
#   config = {
#     juju-http-proxy  = var.http_proxy
#     juju-https-proxy = var.https_proxy
#     juju-no-proxy    = var.no_proxy
#   }
# }

# module "cos" {
#  source = "git::https://github.com/canonical/observability-stack//terraform/cos-lite?ref=04ab6c618dbbec62292a052a61cdb402d80e5974"
#
#   model_uuid   = juju_model.cos.uuid
#   channel      = var.cos_channel
#   internal_tls = false
# }

resource "juju_model" "database" {
  name  = var.db_model_name

  config = {
    juju-http-proxy  = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy    = var.no_proxy
  }
}

module "postgresql" {
  source = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=b7822d93f8d5d0d94ca3da36ea9f5b13f3e58d43"

  model_uuid = juju_model.database.uuid
  app_name   = "general-db"
  channel    = "14/stable"
}

resource "juju_offer" "postgresql" {
  model_uuid = juju_model.database.uuid
  application_name = module.postgresql.app_name
  endpoints        = ["database"]
}

resource "juju_model" "kubeflow" {
  name  = var.kf_model_name
  
  config = {
    juju-http-proxy  = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy    = var.no_proxy
  }

}

module "kubeflow" {
  source = "../../products/kubeflow"

  release            = var.release
  risk               = var.risk
  create_model       = false
  model_uuid         = juju_model.kubeflow.uuid
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

  kserve_controller_config = {
    deployment-mode="standard"
    custom_images="{\"serving_runtimes__huggingfaceserver\": \"kserve/huggingfaceserver:v0.17.1\", \"serving_runtimes__huggingfaceserver__multinode\": \"kserve/huggingfaceserver:v0.17.1\"}"
  }

  # Observability is always enabled in kubeflow-cos and automatically wired to COS
  # enable_observability = true
  # dashboards_offer     = module.cos.offers.grafana_dashboards.url
  # logging_offer        = module.cos.offers.loki_logging.url
  # metrics_offer        = module.cos.offers.prometheus_receive_remote_write.url

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
    profile1 = {
      profile="profile1",
      kafka = {

      }
      opensearch = {

      }
    }
  }
}

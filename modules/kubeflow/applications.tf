
module "admission_webhook" {
  source     = "git::https://github.com/canonical/admission-webhook-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.admission_webhook_revision
  channel    = "latest/beta"
}

module "argo_controller" {
  source     = "git::https://github.com/canonical/argo-operators//charms/argo-controller/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.argo_controller_revision
  channel    = "latest/beta"
}

module "dex_auth" {
  source     = "git::https://github.com/canonical/dex-auth-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    "public-url" : var.public_url,
    "connectors" : var.dex_connectors
    "static-username" : var.dex_static_username
    "static-password" : var.dex_static_password
  }
  revision = var.dex_auth_revision
  channel  = "latest/beta"
}

module "envoy" {
  source     = "git::https://github.com/canonical/envoy-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.envoy_revision
  channel    = "latest/beta"
}

module "istio_ingressgateway" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-gateway/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  app_name   = "istio-ingressgateway"
  config = {
    kind = "ingress",
  }
  revision = var.istio_ingressgateway_revision
  channel  = "latest/beta"
}

module "istio_pilot" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-pilot/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    default-gateway = "kubeflow-gateway",
    "tls-secret-id" : var.istio_tls_secret_id
  }
  revision = var.istio_pilot_revision
  channel  = "latest/beta"
}

module "jupyter_controller" {
  source     = "git::https://github.com/canonical/notebook-operators//charms/jupyter-controller/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.jupyter_controller_revision
  channel    = "latest/beta"
}

module "jupyter_ui" {
  source     = "git::https://github.com/canonical/notebook-operators//charms/jupyter-ui/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config     = var.jupyter_ui_config
  revision   = var.jupyter_ui_revision
  channel    = "latest/beta"
}

module "katib_controller" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-controller/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_controller_revision
  channel    = "latest/beta"
}

module "katib_db" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=main"
  juju_model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  app_name        = "katib-db"
  channel         = "8.0/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.katib_db_size
  revision     = var.katib_db_revision
}

module "katib_db_manager" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-db-manager/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_db_manager_revision
  channel    = "latest/beta"
}

module "katib_ui" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-ui/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_ui_revision
  channel    = "latest/beta"
}

module "kfp_api" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-api/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_api_revision
  channel    = "latest/beta"
}

module "kfp_db" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=main"
  juju_model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  app_name        = "kfp-db"
  channel         = "8.0/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.kfp_db_size
  revision     = var.kfp_db_revision
}

module "kfp_metadata_writer" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-metadata-writer/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_metadata_writer_revision
  channel    = "latest/beta"
}

module "kfp_persistence" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-persistence/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_persistence_revision
  channel    = "latest/beta"
}

module "kfp_profile_controller" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-profile-controller/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_profile_controller_revision
  channel    = "latest/beta"
}

module "kfp_schedwf" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-schedwf/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_schedwf_revision
  channel    = "latest/beta"
}

module "kfp_ui" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-ui/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_ui_revision
  channel    = "latest/beta"
}

module "kfp_viewer" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-viewer/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_viewer_revision
  channel    = "latest/beta"
}

module "kfp_viz" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-viz/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_viz_revision
  channel    = "latest/beta"
}

module "knative_eventing" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-eventing/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    namespace = "knative-eventing"
  }
  revision = var.knative_eventing_revision
  channel  = "latest/beta"
}

module "knative_operator" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-operator/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.knative_operator_revision
  channel    = "latest/beta"
}

module "knative_serving" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-serving/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    http-proxy                = var.http_proxy,
    https-proxy               = var.https_proxy,
    "istio.gateway.namespace" = local.model,
    "istio.gateway.name"      = "kubeflow-gateway",
    namespace                 = "knative-serving",
    no-proxy                  = var.no_proxy,
  }
  revision = var.knative_serving_revision
  channel  = "latest/beta"
}

module "kserve_controller" {
  source     = "git::https://github.com/canonical/kserve-operators//charms/kserve-controller/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    deployment-mode = "serverless",
    http-proxy      = var.http_proxy,
    https-proxy     = var.https_proxy,
    no-proxy        = var.no_proxy,
  }
  revision = var.kserve_controller_revision
  channel  = "latest/beta"
}

module "kubeflow_dashboard" {
  source     = "git::https://github.com/canonical/kubeflow-dashboard-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_dashboard_revision
  channel    = "latest/beta"
}

module "kubeflow_profiles" {
  source     = "git::https://github.com/canonical/kubeflow-profiles-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_profiles_revision
  channel    = "latest/beta"
}

module "kubeflow_roles" {
  source     = "git::https://github.com/canonical/kubeflow-roles-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_roles_revision
  channel    = "latest/beta"
}

module "kubeflow_volumes" {
  source     = "git::https://github.com/canonical/kubeflow-volumes-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_volumes_revision
  channel    = "latest/beta"
}

module "metacontroller_operator" {
  source     = "git::https://github.com/canonical/metacontroller-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.metacontroller_operator_revision
  channel    = "latest/beta"
}

module "mlmd" {
  source     = "git::https://github.com/canonical/mlmd-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  storage_directives = {
    mlmd-data = var.mlmd_size
  }
  revision = var.mlmd_revision
  channel  = "latest/beta"
}

module "minio" {
  source     = "git::https://github.com/canonical/minio-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  storage_directives = {
    minio-data = var.minio_size
  }
  revision = var.minio_revision
  channel  = "latest/beta"
}

module "oidc_gatekeeper" {
  source     = "git::https://github.com/canonical/oidc-gatekeeper-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.oidc_gatekeeper_revision
  channel    = "latest/beta"
}

module "pvcviewer_operator" {
  source     = "git::https://github.com/canonical/pvcviewer-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.pvcviewer_operator_revision
  channel    = "latest/beta"
}

module "tensorboard_controller" {
  source     = "git::https://github.com/canonical/kubeflow-tensorboards-operator//charms/tensorboard-controller/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.tensorboard_controller_revision
  channel    = "latest/beta"
}

module "tensorboards_web_app" {
  source     = "git::https://github.com/canonical/kubeflow-tensorboards-operator//charms/tensorboards-web-app/terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.tensorboards_web_app_revision
  channel    = "latest/beta"
}

module "training_operator" {
  source     = "git::https://github.com/canonical/training-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.training_operator_revision
  channel    = "latest/beta"
}

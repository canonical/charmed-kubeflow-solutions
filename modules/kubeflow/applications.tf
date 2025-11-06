
module "admission_webhook" {
  source     = "git::https://github.com/canonical/admission-webhook-operator//terraform?ref=6b423ffabc7d6449bf120573cf4d9c1388928d61"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.admission_webhook_revision
}

module "argo_controller" {
  source     = "git::https://github.com/canonical/argo-operators//charms/argo-controller/terraform?ref=01e12bb524fbbf9995694b0eadf902fc6d30ecb8"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.argo_controller_revision
}

module "dex_auth" {
  source     = "git::https://github.com/canonical/dex-auth-operator//terraform?ref=d0b488bc375c773e9e8af0d685dbc1d8f7a36f31"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    "public-url" : var.public_url,
    "connectors" : var.dex_connectors
    "static-username" : var.dex_static_username
    "static-password" : var.dex_static_password
  }
  revision = var.dex_auth_revision
}

module "envoy" {
  source     = "git::https://github.com/canonical/envoy-operator//terraform?ref=1b393efa517fefc91c6d32429a335f1f6d0bd2da"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.envoy_revision
}

module "istio_ingressgateway" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-gateway/terraform?ref=a6813881271f85de90aaa0e502561b679628e0f4"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  app_name   = "istio-ingressgateway"
  config = {
    kind = "ingress",
  }
  revision = var.istio_ingressgateway_revision
}

module "istio_pilot" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-pilot/terraform?ref=a6813881271f85de90aaa0e502561b679628e0f4"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    default-gateway = "kubeflow-gateway",
    "tls-secret-id" : var.istio_tls_secret_id
  }
  revision = var.istio_pilot_revision
}

module "jupyter_controller" {
  source     = "git::https://github.com/canonical/notebook-operators//charms/jupyter-controller/terraform?ref=060a0b4cf96d167bcb31553b9e65a0e2f10dee07"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.jupyter_controller_revision
}

module "jupyter_ui" {
  source     = "git::https://github.com/canonical/notebook-operators//charms/jupyter-ui/terraform?ref=060a0b4cf96d167bcb31553b9e65a0e2f10dee07"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config     = var.jupyter_ui_config
  revision   = var.jupyter_ui_revision
}

module "katib_controller" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-controller/terraform?ref=c97bce204ed8cbc2b7fbe87bc70edbd1f5c1c32e"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_controller_revision
}

module "katib_db" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=4f198a8a2787a25da89c1240b3bf7efd1a7d1228"
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
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-db-manager/terraform?ref=c97bce204ed8cbc2b7fbe87bc70edbd1f5c1c32e"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_db_manager_revision
}

module "katib_ui" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-ui/terraform?ref=c97bce204ed8cbc2b7fbe87bc70edbd1f5c1c32e"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_ui_revision
}

module "kfp_api" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-api/terraform?ref=850370c4ba8ab79960c87ad49268c2c930cfd065"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_api_revision
}

module "kfp_db" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=4f198a8a2787a25da89c1240b3bf7efd1a7d1228"
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
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-metadata-writer/terraform?ref=850370c4ba8ab79960c87ad49268c2c930cfd065"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_metadata_writer_revision
}

module "kfp_persistence" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-persistence/terraform?ref=850370c4ba8ab79960c87ad49268c2c930cfd065"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_persistence_revision
}

module "kfp_profile_controller" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-profile-controller/terraform?ref=850370c4ba8ab79960c87ad49268c2c930cfd065"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_profile_controller_revision
}

module "kfp_schedwf" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-schedwf/terraform?ref=850370c4ba8ab79960c87ad49268c2c930cfd065"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_schedwf_revision
}

module "kfp_ui" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-ui/terraform?ref=850370c4ba8ab79960c87ad49268c2c930cfd065"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_ui_revision
}

module "kfp_viewer" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-viewer/terraform?ref=850370c4ba8ab79960c87ad49268c2c930cfd065"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_viewer_revision
}

module "kfp_viz" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-viz/terraform?ref=850370c4ba8ab79960c87ad49268c2c930cfd065"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_viz_revision
}

module "knative_eventing" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-eventing/terraform?ref=67481741c0e2fd24dba69af264e5dc684b1f3919"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    namespace = "knative-eventing"
  }
  revision = var.knative_eventing_revision
}

module "knative_operator" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-operator/terraform?ref=67481741c0e2fd24dba69af264e5dc684b1f3919"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.knative_operator_revision
}

module "knative_serving" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-serving/terraform?ref=67481741c0e2fd24dba69af264e5dc684b1f3919"
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
}

module "kserve_controller" {
  source     = "git::https://github.com/canonical/kserve-operators//charms/kserve-controller/terraform?ref=b18a27ecb10edac4cb55ab9d655faea17e68d1b8"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    deployment-mode = "serverless",
    http-proxy      = var.http_proxy,
    https-proxy     = var.https_proxy,
    no-proxy        = var.no_proxy,
  }
  revision = var.kserve_controller_revision
}

module "kubeflow_dashboard" {
  source     = "git::https://github.com/canonical/kubeflow-dashboard-operator//terraform?ref=c9a5789fc8f967e4583c9af47b7eee926ab05ee3"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_dashboard_revision
}

module "kubeflow_profiles" {
  source     = "git::https://github.com/canonical/kubeflow-profiles-operator//terraform?ref=c924b171db4d3679c4273ce3062e4d73ba419c43"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_profiles_revision
}

module "kubeflow_roles" {
  source     = "git::https://github.com/canonical/kubeflow-roles-operator//terraform?ref=57c22ab4014075658cd9a65c71c70dc714627f66"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_roles_revision
}

module "kubeflow_volumes" {
  source     = "git::https://github.com/canonical/kubeflow-volumes-operator//terraform?ref=2b80e47a846c8679ef0dec9d23d8344639736302"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_volumes_revision
}

module "metacontroller_operator" {
  source     = "git::https://github.com/canonical/metacontroller-operator//terraform?ref=0833d670260bd604c091817dbfbeb2ff676977d6"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.metacontroller_operator_revision
}

module "mlmd" {
  source     = "git::https://github.com/canonical/mlmd-operator//terraform?ref=2c69284ff5bd30e7752e041556d3bf2484319ec1"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  storage_directives = {
    mlmd-data = var.mlmd_size
  }
  revision = var.mlmd_revision
}

module "minio" {
  source     = "git::https://github.com/canonical/minio-operator//terraform?ref=9c1d621124df098c24e00329c0d2e1b12b9bc4fa"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  storage_directives = {
    minio-data = var.minio_size
  }
  revision = var.minio_revision
}

module "oidc_gatekeeper" {
  source     = "git::https://github.com/canonical/oidc-gatekeeper-operator//terraform?ref=6b224f30e1f28bbb0f758661fde3c409ed4f7427"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.oidc_gatekeeper_revision
}

module "pvcviewer_operator" {
  source     = "git::https://github.com/canonical/pvcviewer-operator//terraform?ref=322a8fd518eba084a02fd9a5ba062d150dbc398d"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.pvcviewer_operator_revision
}

module "tensorboard_controller" {
  source     = "git::https://github.com/canonical/kubeflow-tensorboards-operator//charms/tensorboard-controller/terraform?ref=5b56e2b17540378ebd2b0d7d98dc8280492e6b59"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.tensorboard_controller_revision
}

module "tensorboards_web_app" {
  source     = "git::https://github.com/canonical/kubeflow-tensorboards-operator//charms/tensorboards-web-app/terraform?ref=5b56e2b17540378ebd2b0d7d98dc8280492e6b59"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.tensorboards_web_app_revision
}

module "training_operator" {
  source     = "git::https://github.com/canonical/training-operator//terraform?ref=2467ca322a0a79547430fdbe8a3e0f23a494085b"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.training_operator_revision
}

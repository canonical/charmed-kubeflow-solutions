
module "admission_webhook" {
  source     = "git::https://github.com/canonical/admission-webhook-operator//terraform?ref=track/2.0"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.admission_webhook_revision
  channel    = "2.0/${var.risk}"
}

module "argo_controller" {
  source     = "git::https://github.com/canonical/argo-operators//charms/argo-controller/terraform?ref=track/3.7"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.argo_controller_revision
  channel    = "3.7/${var.risk}"
  config = {
    bucket = var.argo_controller_bucket
  }
}

module "dex_auth" {
  source     = "git::https://github.com/canonical/dex-auth-operator//terraform?ref=track/2.41"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    "public-url" : var.public_url,
    "connectors" : var.dex_connectors
    "static-username" : var.dex_static_username
    "static-password" : var.dex_static_password
  }
  revision = var.dex_auth_revision
  channel  = "2.41/${var.risk}"
}

module "envoy" {
  source     = "git::https://github.com/canonical/envoy-operator//terraform?ref=track/2.4"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.envoy_revision
  channel    = "2.4/${var.risk}"
}

module "jupyter_controller" {
  source     = "git::https://github.com/canonical/notebook-operators//charms/jupyter-controller/terraform?ref=track/1.11"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.jupyter_controller_revision
  channel    = "1.11/${var.risk}"
}

module "jupyter_ui" {
  source     = "git::https://github.com/canonical/notebook-operators//charms/jupyter-ui/terraform?ref=track/1.11"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config     = var.jupyter_ui_config
  revision   = var.jupyter_ui_revision
  channel    = "1.11/${var.risk}"
}

module "katib_controller" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-controller/terraform?ref=track/0.19"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_controller_revision
  channel    = "0.19/${var.risk}"
}

module "katib_db" {
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=eb6261e6fd1830d80aa4fa260d091c9110c24ba4"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  app_name   = "katib-db"
  channel    = "8.0/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.katib_db_size
  revision     = var.katib_db_revision
}

module "katib_db_manager" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-db-manager/terraform?ref=track/0.19"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_db_manager_revision
  channel    = "0.19/${var.risk}"
}

module "katib_ui" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-ui/terraform?ref=track/0.19"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_ui_revision
  channel    = "0.19/${var.risk}"
}

module "kfp_api" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-api/terraform?ref=track/2.16"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_api_revision
  config = {
    object-store-bucket-name = var.kfp_api_object_store_bucket_name
  }
  channel = "2.16/${var.risk}"
}

module "kfp_db" {
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=eb6261e6fd1830d80aa4fa260d091c9110c24ba4"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  app_name   = "kfp-db"
  channel    = "8.0/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.kfp_db_size
  revision     = var.kfp_db_revision
}

module "kfp_metadata_writer" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-metadata-writer/terraform?ref=track/2.16"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_metadata_writer_revision
  channel    = "2.16/${var.risk}"
}

module "kfp_persistence" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-persistence/terraform?ref=track/2.16"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_persistence_revision
  channel    = "2.16/${var.risk}"
}

module "kfp_profile_controller" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-profile-controller/terraform?ref=track/2.16"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_profile_controller_revision
  channel    = "2.16/${var.risk}"
}

module "kfp_schedwf" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-schedwf/terraform?ref=track/2.16"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_schedwf_revision
  channel    = "2.16/${var.risk}"
}

module "kfp_ui" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-ui/terraform?ref=track/2.16"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_ui_revision
  channel    = "2.16/${var.risk}"
}

module "kfp_viewer" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-viewer/terraform?ref=track/2.16"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_viewer_revision
  channel    = "2.16/${var.risk}"
}

module "kfp_viz" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-viz/terraform?ref=track/2.16"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_viz_revision
  channel    = "2.16/${var.risk}"
}

module "kserve_controller" {
  source     = "git::https://github.com/canonical/kserve-operators//charms/kserve-controller/terraform?ref=track/0.15"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    deployment-mode = "RawDeployment",
    http-proxy      = var.http_proxy,
    https-proxy     = var.https_proxy,
    no-proxy        = var.no_proxy,
  }
  revision = var.kserve_controller_revision
  channel  = "0.15/${var.risk}"
}

module "kubeflow_dashboard" {
  source     = "git::https://github.com/canonical/kubeflow-dashboard-operator//terraform?ref=track/2.0"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    "registration-flow" : var.kubeflow_dashboard_registration_flow
  }
  revision = var.kubeflow_dashboard_revision
  channel  = "2.0/${var.risk}"
}

module "kubeflow_profiles" {
  source     = "git::https://github.com/canonical/kubeflow-profiles-operator//terraform?ref=track/2.0"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    "security-policy" : var.kubeflow_profiles_security_policy
    "service-mesh-mode" : "istio-ambient"
    "istio-gateway-service-account" : "istio-ingress-k8s-istio"
  }
  revision = var.kubeflow_profiles_revision
  channel  = "2.0/${var.risk}"
}

module "kubeflow_roles" {
  source     = "git::https://github.com/canonical/kubeflow-roles-operator//terraform?ref=track/1.10"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_roles_revision
  channel    = "1.10/${var.risk}"
}

module "kubeflow_trainer" {
  count      = var.kubeflow_trainer_v2 ? 1 : 0
  source     = "git::https://github.com/canonical/kubeflow-trainer-operator//terraform?ref=main"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_trainer_revision
  channel    = "2.1/edge"
}

module "kubeflow_volumes" {
  source     = "git::https://github.com/canonical/kubeflow-volumes-operator//terraform?ref=track/1.11"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_volumes_revision
  channel    = "1.11/${var.risk}"
}

module "metacontroller_operator" {
  source     = "git::https://github.com/canonical/metacontroller-operator//terraform?ref=track/4.11"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.metacontroller_operator_revision
  channel    = "4.11/${var.risk}"
}

module "mlmd" {
  source     = "git::https://github.com/canonical/mlmd-operator//terraform?ref=track/ckf-1.10"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  storage_directives = {
    mlmd-data = var.mlmd_size
  }
  revision = var.mlmd_revision
  channel  = "ckf-1.10/${var.risk}"
}

module "minio" {
  source     = "git::https://github.com/canonical/minio-operator//terraform?ref=track/1.10"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    access-key               = var.minio_access_key,
    secret-key               = var.minio_secret_key,
    mode                     = var.minio_mode,
    gateway-storage-service  = var.minio_gateway_storage_service,
    storage-service-endpoint = var.minio_storage_service_endpoint,
  }
  storage_directives = {
    minio-data = var.minio_size
  }
  revision = var.minio_revision
  channel  = "1.10/${var.risk}"
}

module "oidc_gatekeeper" {
  source     = "git::https://github.com/canonical/oidc-gatekeeper-operator//terraform?ref=track/ckf-1.10"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    ca-bundle = var.oidc_gatekeeper_ca_bundle,
  }
  revision = var.oidc_gatekeeper_revision
  channel  = "ckf-1.10/${var.risk}"
}

module "pvcviewer_operator" {
  source     = "git::https://github.com/canonical/pvcviewer-operator//terraform?ref=track/1.11"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.pvcviewer_operator_revision
  channel    = "1.11/${var.risk}"
}

module "tensorboard_controller" {
  source     = "git::https://github.com/canonical/kubeflow-tensorboards-operator//charms/tensorboard-controller/terraform?ref=track/1.11"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.tensorboard_controller_revision
  channel    = "1.11/${var.risk}"
}

module "tensorboards_web_app" {
  source     = "git::https://github.com/canonical/kubeflow-tensorboards-operator//charms/tensorboards-web-app/terraform?ref=track/1.11"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.tensorboards_web_app_revision
  channel    = "1.11/${var.risk}"
}

module "training_operator" {
  source     = "git::https://github.com/canonical/training-operator//terraform?ref=track/1.9"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.training_operator_revision
  channel    = "1.9/${var.risk}"
}

resource "juju_application" "istio_k8s" {
  name  = "istio-k8s"
  model = var.create_model ? juju_model.kubeflow[0].name : local.model
  trust = true
  config = {
    platform = var.istio_k8s_platform
  }

  charm {
    name     = "istio-k8s"
    channel  = "2/stable"
    revision = var.istio_k8s_revision
  }
}

resource "juju_application" "istio_ingress_k8s" {
  name  = "istio-ingress-k8s"
  model = var.create_model ? juju_model.kubeflow[0].name : local.model
  trust = true

  charm {
    name     = "istio-ingress-k8s"
    channel  = "2/stable"
    revision = var.istio_ingress_k8s_revision
  }
}

resource "juju_application" "istio_beacon_k8s" {
  name  = "istio-beacon-k8s"
  model = var.create_model ? juju_model.kubeflow[0].name : local.model
  trust = true

  charm {
    name     = "istio-beacon-k8s"
    channel  = "2/stable"
    revision = var.istio_beacon_k8s_revision
  }
}

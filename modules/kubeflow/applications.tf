
module "admission_webhook" {
  source     = "git::https://github.com/canonical/admission-webhook-operator//terraform?ref=00ec384791ce8a68dc2e1d9ce9a804edc0b84719"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.admission_webhook_revision
  channel    = "1.10/${var.risk}"
}

module "argo_controller" {
  source     = "git::https://github.com/canonical/argo-operators//charms/argo-controller/terraform?ref=2c185575bd189ae611014c62653f8af1d1080668"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.argo_controller_revision
  channel    = "3.5/${var.risk}"
  config = {
    bucket = var.argo_controller_bucket
  }
}

module "dex_auth" {
  source     = "git::https://github.com/canonical/dex-auth-operator//terraform?ref=8737a16f95c5ca1dbd56ccf0be43273de1584fbb"
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
  source     = "git::https://github.com/canonical/envoy-operator//terraform?ref=73def4365b9177e382dce9bce35b61a41b1e8513"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.envoy_revision
  channel    = "2.4/${var.risk}"
}

module "istio_ingressgateway" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-gateway/terraform?ref=cc088bb79bf06013e9113dabff6e0f4b6e5b012d"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  app_name   = "istio-ingressgateway"
  config = {
    kind        = "ingress",
    annotations = var.istio_ingressgateway_annotations,
  }
  revision = var.istio_ingressgateway_revision
  channel  = "1.24/${var.risk}"
}

module "istio_pilot" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-pilot/terraform?ref=cc088bb79bf06013e9113dabff6e0f4b6e5b012d"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    default-gateway = "kubeflow-gateway",
    "tls-secret-id" : var.istio_tls_secret_id
  }
  revision = var.istio_pilot_revision
  channel  = "1.24/${var.risk}"
}

module "jupyter_controller" {
  source     = "git::https://github.com/canonical/notebook-operators//charms/jupyter-controller/terraform?ref=248e523262c125dec1e0902ec9284b763da9e217"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.jupyter_controller_revision
  channel    = "1.10/${var.risk}"
}

module "jupyter_ui" {
  source     = "git::https://github.com/canonical/notebook-operators//charms/jupyter-ui/terraform?ref=248e523262c125dec1e0902ec9284b763da9e217"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config     = var.jupyter_ui_config
  revision   = var.jupyter_ui_revision
  channel    = "1.10/${var.risk}"
}

module "katib_controller" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-controller/terraform?ref=55e45e2a9a4a9864144293ace91147ec8cc6842d"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_controller_revision
  channel    = "0.18/${var.risk}"
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
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-db-manager/terraform?ref=55e45e2a9a4a9864144293ace91147ec8cc6842d"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_db_manager_revision
  channel    = "0.18/${var.risk}"
}

module "katib_ui" {
  source     = "git::https://github.com/canonical/katib-operators//charms/katib-ui/terraform?ref=55e45e2a9a4a9864144293ace91147ec8cc6842d"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.katib_ui_revision
  channel    = "0.18/${var.risk}"
}

module "kfp_api" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-api/terraform?ref=20ba40048bd5982f9e8f6b5f70d9020eb9bc51eb"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_api_revision
  config = {
    object-store-bucket-name = var.kfp_api_object_store_bucket_name
  }
  channel = "2.5/${var.risk}"
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
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-metadata-writer/terraform?ref=20ba40048bd5982f9e8f6b5f70d9020eb9bc51eb"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_metadata_writer_revision
  channel    = "2.5/${var.risk}"
}

module "kfp_persistence" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-persistence/terraform?ref=20ba40048bd5982f9e8f6b5f70d9020eb9bc51eb"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_persistence_revision
  channel    = "2.5/${var.risk}"
}

module "kfp_profile_controller" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-profile-controller/terraform?ref=20ba40048bd5982f9e8f6b5f70d9020eb9bc51eb"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_profile_controller_revision
  channel    = "2.5/${var.risk}"
}

module "kfp_schedwf" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-schedwf/terraform?ref=20ba40048bd5982f9e8f6b5f70d9020eb9bc51eb"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_schedwf_revision
  channel    = "2.5/${var.risk}"
}

module "kfp_ui" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-ui/terraform?ref=20ba40048bd5982f9e8f6b5f70d9020eb9bc51eb"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_ui_revision
  channel    = "2.5/${var.risk}"
}

module "kfp_viewer" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-viewer/terraform?ref=20ba40048bd5982f9e8f6b5f70d9020eb9bc51eb"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_viewer_revision
  channel    = "2.5/${var.risk}"
}

module "kfp_viz" {
  source     = "git::https://github.com/canonical/kfp-operators//charms/kfp-viz/terraform?ref=20ba40048bd5982f9e8f6b5f70d9020eb9bc51eb"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kfp_viz_revision
  channel    = "2.5/${var.risk}"
}

module "knative_eventing" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-eventing/terraform?ref=df3044e7b393a174d59a2c26c09789ab23ad10de"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    namespace = "knative-eventing"
  }
  revision = var.knative_eventing_revision
  channel  = "1.16/${var.risk}"
}

module "knative_operator" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-operator/terraform?ref=df3044e7b393a174d59a2c26c09789ab23ad10de"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.knative_operator_revision
  channel    = "1.16/${var.risk}"
}

module "knative_serving" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-serving/terraform?ref=df3044e7b393a174d59a2c26c09789ab23ad10de"
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
  channel  = "1.16/${var.risk}"
}

module "kserve_controller" {
  source     = "git::https://github.com/canonical/kserve-operators//charms/kserve-controller/terraform?ref=2736e571582dc38742a4e30f8555dbc178543b1c"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    deployment-mode = "serverless",
    http-proxy      = var.http_proxy,
    https-proxy     = var.https_proxy,
    no-proxy        = var.no_proxy,
  }
  revision = var.kserve_controller_revision
  channel  = "0.14/${var.risk}"
}

module "kubeflow_dashboard" {
  source     = "git::https://github.com/canonical/kubeflow-dashboard-operator//terraform?ref=4725b1da3701ada73ec231dddd8bb15c5522bed3"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    "registration-flow" : var.kubeflow_dashboard_registration_flow
  }
  revision = var.kubeflow_dashboard_revision
  channel  = "1.10/${var.risk}"
}

module "kubeflow_profiles" {
  source     = "git::https://github.com/canonical/kubeflow-profiles-operator//terraform?ref=2a0f9e5ceab30226293867f46decb5e5ec9444da"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_profiles_revision
  channel    = "1.10/${var.risk}"
}

module "kubeflow_roles" {
  source     = "git::https://github.com/canonical/kubeflow-roles-operator//terraform?ref=79d5dd3e2d504ed495ae33698a4863a8658cf704"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_roles_revision
  channel    = "1.10/${var.risk}"
}

module "kubeflow_volumes" {
  source     = "git::https://github.com/canonical/kubeflow-volumes-operator//terraform?ref=5327c8f4d7ac428a888f6eb86f359e12cd95d034"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.kubeflow_volumes_revision
  channel    = "1.10/${var.risk}"
}

module "metacontroller_operator" {
  source     = "git::https://github.com/canonical/metacontroller-operator//terraform?ref=ad0dd384a65c0bfe157611aaec7743f0e3360579"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.metacontroller_operator_revision
  channel    = "4.11/${var.risk}"
}

module "mlmd" {
  source     = "git::https://github.com/canonical/mlmd-operator//terraform?ref=ce07ddb897b24c0036c5cbb524d518f1ad3ea343"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  storage_directives = {
    mlmd-data = var.mlmd_size
  }
  revision = var.mlmd_revision
  channel  = "ckf-1.10/${var.risk}"
}

module "minio" {
  source     = "git::https://github.com/canonical/minio-operator//terraform?ref=d72b4090c0928d3480da87cefd6799c7b13dc45e"
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
  source     = "git::https://github.com/canonical/oidc-gatekeeper-operator//terraform?ref=1d8c9b0468f8439ff350ea04f8b6f1e42a153024"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  config = {
    ca-bundle = var.oidc_gatekeeper_ca_bundle,
  }
  revision = var.oidc_gatekeeper_revision
  channel  = "ckf-1.10/${var.risk}"
}

module "pvcviewer_operator" {
  source     = "git::https://github.com/canonical/pvcviewer-operator//terraform?ref=5c43cae99093acc4c242f5ea56467c4cc492d8d3"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.pvcviewer_operator_revision
  channel    = "1.10/${var.risk}"
}

module "tensorboard_controller" {
  source     = "git::https://github.com/canonical/kubeflow-tensorboards-operator//charms/tensorboard-controller/terraform?ref=370b22ac4f46a23f0ee30b37dce4fe25497b9dc2"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.tensorboard_controller_revision
  channel    = "1.10/${var.risk}"
}

module "tensorboards_web_app" {
  source     = "git::https://github.com/canonical/kubeflow-tensorboards-operator//charms/tensorboards-web-app/terraform?ref=370b22ac4f46a23f0ee30b37dce4fe25497b9dc2"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.tensorboards_web_app_revision
  channel    = "1.10/${var.risk}"
}

module "training_operator" {
  source     = "git::https://github.com/canonical/training-operator//terraform?ref=18d07d2d446b2a9e344f651c5555c889c30c5bd7"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
  revision   = var.training_operator_revision
  channel    = "1.9/${var.risk}"
}

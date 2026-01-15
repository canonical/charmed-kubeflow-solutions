module "kubeflow" {
  source                               = "../kubeflow"
  risk                                 = var.risk
  argo_controller_bucket               = var.argo_controller_bucket
  create_model                         = var.create_model
  cos_configuration                    = var.cos_configuration
  dex_connectors                       = var.dex_connectors
  dex_static_username                  = var.dex_static_username
  dex_static_password                  = var.dex_static_password
  existing_opentelemetry_collector_name = var.cos_configuration ? var.existing_opentelemetry_collector_name : null
  opentelemetry_collector_k8s_size      = var.opentelemetry_collector_k8s_size
  http_proxy                           = var.http_proxy
  https_proxy                          = var.https_proxy
  istio_cni_bin_dir                    = var.istio_cni_bin_dir
  istio_cni_conf_dir                   = var.istio_cni_conf_dir
  istio_tls_secret_id                  = var.istio_tls_secret_id
  jupyter_ui_config                    = var.jupyter_ui_config
  katib_db_size                        = var.katib_db_size
  kfp_api_object_store_bucket_name     = var.kfp_api_object_store_bucket_name
  kfp_db_size                          = var.kfp_db_size
  kubeflow_profiles_security_policy    = var.kubeflow_profiles_security_policy
  minio_access_key                     = var.minio_access_key
  minio_gateway_storage_service        = var.minio_gateway_storage_service
  minio_mode                           = var.minio_mode
  minio_secret_key                     = var.minio_secret_key
  minio_size                           = var.minio_size
  minio_storage_service_endpoint       = var.minio_storage_service_endpoint
  mlmd_size                            = var.mlmd_size
  no_proxy                             = var.no_proxy
  public_url                           = var.public_url
  admission_webhook_revision           = var.admission_webhook_revision
  argo_controller_revision             = var.argo_controller_revision
  dex_auth_revision                    = var.dex_auth_revision
  envoy_revision                       = var.envoy_revision
  istio_ingressgateway_revision        = var.istio_ingressgateway_revision
  istio_ingressgateway_annotations     = var.istio_ingressgateway_annotations
  istio_pilot_revision                 = var.istio_pilot_revision
  jupyter_controller_revision          = var.jupyter_controller_revision
  jupyter_ui_revision                  = var.jupyter_ui_revision
  katib_controller_revision            = var.katib_controller_revision
  katib_db_revision                    = var.katib_db_revision
  katib_db_manager_revision            = var.katib_db_manager_revision
  katib_ui_revision                    = var.katib_ui_revision
  kfp_api_revision                     = var.kfp_api_revision
  kfp_db_revision                      = var.kfp_db_revision
  kfp_metadata_writer_revision         = var.kfp_metadata_writer_revision
  kfp_persistence_revision             = var.kfp_persistence_revision
  kfp_profile_controller_revision      = var.kfp_profile_controller_revision
  kfp_schedwf_revision                 = var.kfp_schedwf_revision
  kfp_ui_revision                      = var.kfp_ui_revision
  kfp_viewer_revision                  = var.kfp_viewer_revision
  kfp_viz_revision                     = var.kfp_viz_revision
  knative_eventing_revision            = var.knative_eventing_revision
  knative_operator_revision            = var.knative_operator_revision
  knative_serving_revision             = var.knative_serving_revision
  kserve_controller_revision           = var.kserve_controller_revision
  kubeflow_dashboard_revision          = var.kubeflow_dashboard_revision
  kubeflow_dashboard_registration_flow = var.kubeflow_dashboard_registration_flow
  kubeflow_profiles_revision           = var.kubeflow_profiles_revision
  kubeflow_roles_revision              = var.kubeflow_roles_revision
  kubeflow_volumes_revision            = var.kubeflow_volumes_revision
  metacontroller_operator_revision     = var.metacontroller_operator_revision
  mlmd_revision                        = var.mlmd_revision
  minio_revision                       = var.minio_revision
  oidc_gatekeeper_revision             = var.oidc_gatekeeper_revision
  oidc_gatekeeper_ca_bundle            = var.oidc_gatekeeper_ca_bundle
  pvcviewer_operator_revision          = var.pvcviewer_operator_revision
  tensorboard_controller_revision      = var.tensorboard_controller_revision
  tensorboards_web_app_revision        = var.tensorboards_web_app_revision
  training_operator_revision           = var.training_operator_revision
}

module "resource_dispatcher" {
  source     = "git::https://github.com/canonical/resource-dispatcher//terraform?ref=893c73d48f49023f0cf3aa13927a609167d53bf7"
  model_name = module.kubeflow.model
  revision   = var.resource_dispatcher_revision
  channel    = "2.0/${var.risk}"
}


resource "juju_application" "integration_hub" {
  model = module.kubeflow.model
  name  = "integration-hub"
  charm {
    name    = "spark-integration-hub-k8s"
    channel = "3/edge" # TODO: fix hardcoded value
  }
  units       = 1
  trust       = true
  constraints = "arch=amd64"
}

resource "juju_application" "kubeflow_integrator" {
  model = module.kubeflow.model
  name  = "kubeflow-integrator"
  charm {
    name    = "data-kubeflow-integrator"
    channel = "1/edge" # TODO: fix hardcoded value
  }
  units       = 1
  constraints = "arch=amd64"
  trust       = true
  config = {
    spark-service-account = var.kubeflow_spark_service_account
    profile               = var.kubeflow_spark_profile
  }
}


module "kubeflow" {
  source     = "git::https://github.com/canonical/charmed-kubeflow-solutions//modules/kubeflow?ref=kf-6272-feat-kubeflow-solution"
  create_model = var.create_model
  cos_configuration = var.cos_configuration
  dex_connectors = var.dex_connectors
  grafana_agent_k8s_size = var.grafana_agent_k8s_size
  http_proxy = var.http_proxy
  https_proxy = var.https_proxy
  istio_tls_secret_id = var.istio_tls_secret_id
  jupyter_ui_config = var.jupyter_ui_config
  katib_db_size = var.katib_db_size
  kfp_db_size = var.kfp_db_size
  minio_size = var.minio_size
  mlmd_size = var.mlmd_size
  no_proxy = var.no_proxy
  public_url = var.public_url
  admission_webhook_revision = var.admission_webhook_revision
  argo_controller_revision = var.argo_controller_revision
  dex_auth_revision = var.dex_auth_revision
  envoy_revision = var.envoy_revision
  istio_ingressgateway_revision = var.istio_ingressgateway_revision
  istio_pilot_revision = var.istio_pilot_revision
  jupyter_controller_revision = var.jupyter_controller_revision
  jupyter_ui_revision = var.jupyter_ui_revision
  katib_controller_revision = var.katib_controller_revision
  katib_db_revision = var.katib_db_revision
  katib_db_manager_revision = var.katib_db_manager_revision
  katib_ui_revision = var.katib_ui_revision
  kfp_api_revision = var.kfp_api_revision
  kfp_db_revision = var.kfp_db_revision
  kfp_metadata_writer_revision = var.kfp_metadata_writer_revision
  kfp_persistence_revision = var.kfp_persistence_revision
  kfp_profile_controller_revision = var.kfp_profile_controller_revision
  kfp_schedwf_revision = var.kfp_schedwf_revision
  kfp_ui_revision = var.kfp_ui_revision
  kfp_viewer_revision = var.kfp_viewer_revision
  kfp_viz_revision = var.kfp_viz_revision
  knative_eventing_revision = var.knative_eventing_revision
  knative_operator_revision = var.knative_operator_revision
  knative_serving_revision = var.knative_serving_revision
  kserve_controller_revision = var.kserve_controller_revision
  kubeflow_dashboard_revision = var.kubeflow_dashboard_revision
  kubeflow_profiles_revision = var.kubeflow_profiles_revision
  kubeflow_roles_revision = var.kubeflow_roles_revision
  kubeflow_volumes_revision = var.kubeflow_volumes_revision
  metacontroller_operator_revision = var.metacontroller_operator_revision
  mlmd_revision = var.mlmd_revision
  minio_revision = var.minio_revision
  oidc_gatekeeper_revision = var.oidc_gatekeeper_revision
  pvcviewer_operator_revision = var.pvcviewer_operator_revision
  tensorboard_controller_revision = var.tensorboard_controller_revision
  tensorboards_web_app_revision = var.tensorboards_web_app_revision
  training_operator_revision = var.training_operator_revision
  grafana_agent_k8s_revision = var.grafana_agent_k8s_revision
}

module "mlflow" {
  source     = "git::https://github.com/canonical/charmed-mlflow-solutions//modules/mlflow?ref=KF-6273-mlflow-bundle-terraform"
  # Either kubeflow module will create the model, or it will be provided by a higher-level module
  create_model = false
  model = var.create_model ? juju_model.kubeflow[0].name : local.model_name
  cos_configuration = var.cos_configuration
  existing_grafana_agent_name = var.cos_configuration ? module.kubeflow.grafana_agent_k8s.app_name : null
  mlflow_minio_revision = var.mlflow_minio_revision
  mlflow_minio_size = var.mlflow_minio_size
  mlflow_mysql_revision = var.mlflow_mysql_revision
  mlflow_mysql_size = var.mlflow_mysql_size
  mlflow_server_revision = var.mlflow_server_revision
}

module "resource_dispatcher" {
  source     = "git::https://github.com/canonical/resource-dispatcher//terraform?ref=track/2.0"
  model_name = var.create_model ? juju_model.kubeflow[0].name : local.model_name
  revision   = var.resource_dispatcher_revision
}

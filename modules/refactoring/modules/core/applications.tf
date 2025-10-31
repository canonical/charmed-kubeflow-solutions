data "juju_model" "kubeflow" {
  name = var.model
}

resource "juju_application" "admission_webhook" {
  charm {
    name     = "admission-webhook"
    channel  = var.admission_webhook.channel ? var.admission_webhook.channel : "1.10/${var.risk}"
    revision = var.admission_webhook.revision
  }
  config    = var.admission_webhook.config
  model     = data.juju_model.kubeflow.name
  name      = var.admission_webhook.name
  # resources = var.resources
  trust     = true
  units     = 1
}


# module "admission_webhook" {
#   source     = "git::https://github.com/canonical/admission-webhook-operator//terraform?ref=track/1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   revision   = var.admission_webhook_revision
#   channel    = "1.10/${var.risk}"
# }
#
# module "argo_controller" {
#   source     = "git::https://github.com/canonical/argo-operators//charms/argo-controller/terraform?ref=track/3.5"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   revision   = var.argo_controller_revision
#   channel    = "3.5/${var.risk}"
#   config = {
#     bucket = var.argo_controller_bucket
#   }
# }
#
# module "dex_auth" {
#   source     = "git::https://github.com/canonical/dex-auth-operator//terraform?ref=track/2.41"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   config = {
#     "public-url" : var.public_url,
#     "connectors" : var.dex_connectors
#     "static-username" : var.dex_static_username
#     "static-password" : var.dex_static_password
#   }
#   revision = var.dex_auth_revision
#   channel  = "2.41/${var.risk}"
# }
#
# module "envoy" {
#   source     = "git::https://github.com/canonical/envoy-operator//terraform?ref=track/2.4"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   revision   = var.envoy_revision
#   channel    = "2.4/${var.risk}"
# }
#
# module "istio_ingressgateway" {
#   source     = "git::https://github.com/canonical/istio-operators//charms/istio-gateway/terraform?ref=track/1.24"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   app_name   = "istio-ingressgateway"
#   config = {
#     kind        = "ingress",
#     annotations = var.istio_ingressgateway_annotations,
#   }
#   revision = var.istio_ingressgateway_revision
#   channel  = "1.24/${var.risk}"
# }
#
# module "istio_pilot" {
#   source     = "git::https://github.com/canonical/istio-operators//charms/istio-pilot/terraform?ref=track/1.24"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   config = {
#     default-gateway = "kubeflow-gateway",
#     "tls-secret-id" : var.istio_tls_secret_id
#   }
#   revision = var.istio_pilot_revision
#   channel  = "1.24/${var.risk}"
# }
#
# module "kubeflow_dashboard" {
#   source     = "git::https://github.com/canonical/kubeflow-dashboard-operator//terraform?ref=track/1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   config = {
#     "registration-flow" : var.kubeflow_dashboard_registration_flow
#   }
#   revision = var.kubeflow_dashboard_revision
#   channel  = "1.10/${var.risk}"
# }
#
# module "kubeflow_profiles" {
#   source     = "git::https://github.com/canonical/kubeflow-profiles-operator//terraform?ref=track/1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   revision   = var.kubeflow_profiles_revision
#   channel    = "1.10/${var.risk}"
# }
#
# module "kubeflow_roles" {
#   source     = "git::https://github.com/canonical/kubeflow-roles-operator//terraform?ref=track/1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   revision   = var.kubeflow_roles_revision
#   channel    = "1.10/${var.risk}"
# }
#
# module "kubeflow_volumes" {
#   source     = "git::https://github.com/canonical/kubeflow-volumes-operator//terraform?ref=track/1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   revision   = var.kubeflow_volumes_revision
#   channel    = "1.10/${var.risk}"
# }
#
# module "metacontroller_operator" {
#   source     = "git::https://github.com/canonical/metacontroller-operator//terraform?ref=track/4.11"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   revision   = var.metacontroller_operator_revision
#   channel    = "4.11/${var.risk}"
# }
#
# module "mlmd" {
#   source     = "git::https://github.com/canonical/mlmd-operator//terraform?ref=track/ckf-1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   storage_directives = {
#     mlmd-data = var.mlmd_size
#   }
#   revision = var.mlmd_revision
#   channel  = "ckf-1.10/${var.risk}"
# }
#
# module "minio" {
#   source     = "git::https://github.com/canonical/minio-operator//terraform?ref=track/ckf-1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   config = {
#     access-key               = var.minio_access_key,
#     secret-key               = var.minio_secret_key,
#     mode                     = var.minio_mode,
#     gateway-storage-service  = var.minio_gateway_storage_service,
#     storage-service-endpoint = var.minio_storage_service_endpoint,
#   }
#   storage_directives = {
#     minio-data = var.minio_size
#   }
#   revision = var.minio_revision
#   channel  = "ckf-1.10/${var.risk}"
# }
#
# module "oidc_gatekeeper" {
#   source     = "git::https://github.com/canonical/oidc-gatekeeper-operator//terraform?ref=track/ckf-1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   config = {
#     ca-bundle = var.oidc_gatekeeper_ca_bundle,
#   }
#   revision = var.oidc_gatekeeper_revision
#   channel  = "ckf-1.10/${var.risk}"
# }
#
# module "pvcviewer_operator" {
#   source     = "git::https://github.com/canonical/pvcviewer-operator//terraform?ref=track/1.10"
#   model_name = var.create_model ? juju_model.kubeflow[0].name : local.model
#   revision   = var.pvcviewer_operator_revision
#   channel    = "1.10/${var.risk}"
# }
#
#
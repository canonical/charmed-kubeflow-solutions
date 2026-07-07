# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  # Name of the kubeflow model (falls back to "kubeflow" when deploying into an
  # existing model referenced only by UUID).
  kubeflow_model_name = var.create_model ? juju_model.kubeflow[0].name : "kubeflow"

  # Auth Component
  dex_auth_channel        = var.release == "1.11" ? "2.41/${var.risk}" : "latest/${var.risk}"
  oidc_gatekeeper_channel = var.release == "1.11" ? "ckf-1.10/${var.risk}" : "latest/${var.risk}"

  # Core Component
  admission_webhook_channel       = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"
  kubeflow_dashboard_channel      = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"
  kubeflow_profiles_channel       = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"
  kubeflow_roles_channel          = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"
  kubeflow_volumes_channel        = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"
  metacontroller_operator_channel = var.release == "1.11" ? "4.11/${var.risk}" : "latest/${var.risk}"
  pvcviewer_operator_channel      = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"

  # KFP Component
  kfp_channel             = var.release == "1.11" ? "2.15/${var.risk}" : "latest/${var.risk}"
  argo_controller_channel = var.release == "1.11" ? "3.7/${var.risk}" : "latest/${var.risk}"
  mlmd_channel            = var.release == "1.11" ? "ckf-1.10/${var.risk}" : "latest/${var.risk}"
  envoy_channel           = var.release == "1.11" ? "2.4/${var.risk}" : "latest/${var.risk}"

  # Standalone Charms
  minio_channel = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"

  # Istio Component (sidecar)
  istio_sidecar_channel = var.release == "1.11" ? "1.28/${var.risk}" : "latest/${var.risk}"

  # Istio Component (ambient gateways + beacon)
  # NOTE: the ambient IAM architecture needs the istio-ingress-route,
  # gateway-metadata and istio-request-auth endpoints, which are currently only
  # published on the `dev/edge` channel of the Istio charms (2/* and 1/* predate
  # them). Move these back to a stable track once those endpoints graduate.
  istio_ingress_k8s_channel = "dev/edge"
  istio_beacon_k8s_channel  = "dev/edge"

  # IAM Auth Charms (ambient)
  oauth2_proxy_channel                        = "latest/edge"
  request_authentication_configurator_channel = "latest/edge"
  github_profiles_automator_channel           = "latest/edge"

  # Katib Component
  katib_channel = var.release == "1.11" ? "0.19/${var.risk}" : "latest/${var.risk}"

  # Notebooks Component
  notebooks_channel = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"

  # Tensorboard Component
  tensorboard_channel = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"

  # Resource Dispatcher Charm
  resource_dispatcher_channel = var.release == "1.11" ? "2.0/${var.risk}" : "latest/${var.risk}"

  # MLflow Component
  mlflow_channel = var.release == "1.11" ? "2.22/${var.risk}" : "latest/${var.risk}"

  # KServe Component
  kserve_channel  = var.release == "1.11" ? "0.15/${var.risk}" : "latest/${var.risk}"
  knative_channel = var.release == "1.11" ? "1.16/${var.risk}" : "latest/${var.risk}"
  deploy_kserve   = var.enable_kserve || var.enable_mlflow
  deploy_minio    = var.enable_kfp || var.enable_mlflow
  deploy_mysql    = var.enable_kfp || var.enable_katib || var.enable_mlflow

  # Feast Component
  feast_channel = var.release == "1.11" ? "0.49/${var.risk}" : "latest/${var.risk}"

  # Training Component
  training_operator_channel = var.release == "1.11" ? "1.9/${var.risk}" : "latest/${var.risk}"
  kubeflow_trainer_channel  = var.release == "1.11" ? "2.1/edge" : "latest/${var.risk}"

  kubeflow_profiles_service_mesh_config = var.service_mesh_type == "ambient" ? {
    "service-mesh-mode"             = "istio-ambient"
    "istio-gateway-service-account" = "istio-ingress-k8s-ui-istio"
    } : {
    "service-mesh-mode"             = "istio-sidecar"
    "istio-gateway-service-account" = "istio-ingressgateway-workload-service-account"
  }

  kubeflow_profiles = {
    channel  = local.kubeflow_profiles_channel
    revision = var.kubeflow_profiles_revision
    config   = merge(local.kubeflow_profiles_service_mesh_config, var.kubeflow_profiles_config)
  }

  external_integrations = merge(
    var.external_integrations,
    var.enable_spark ? {
      spark-integrator = {
        profile    = "*"
        mysql      = null
        postgresql = null
        spark = {
          kind            = "endpoint"
          name            = module.spark[0].provides.integration_hub_service_account.name
          endpoint        = module.spark[0].provides.integration_hub_service_account.endpoint
          service_account = "spark-user"
          url             = null
        }
      }
    } : {}
  )

  # ------------------------------------------------------------------
  # Ambient gateway / service-mesh selectors (null when sidecar).
  # istio-k8s runs in the istio-system model; the two gateways and the
  # beacon are deployed by the istio-ambient component in this model.
  # ------------------------------------------------------------------
  ambient = var.service_mesh_type == "ambient"

  ui_istio_ingress_route = local.ambient ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_ui_istio_ingress_route.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_ui_istio_ingress_route.endpoint
  } : null

  ui_gateway_metadata = local.ambient ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_ui_gateway_metadata.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_ui_gateway_metadata.endpoint
  } : null

  m2m_gateway_metadata = local.ambient ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_m2m_gateway_metadata.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_m2m_gateway_metadata.endpoint
  } : null

  service_mesh = local.ambient ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

}


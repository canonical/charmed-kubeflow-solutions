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
  admission_webhook_channel       = var.release == "1.11" ? "2.0/${var.risk}" : "latest/${var.risk}"
  kubeflow_dashboard_channel      = var.release == "1.11" ? "2.0/${var.risk}" : "latest/${var.risk}"
  kubeflow_profiles_channel       = var.release == "1.11" ? "2.0/${var.risk}" : "latest/${var.risk}"
  kubeflow_roles_channel          = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"
  kubeflow_volumes_channel        = var.release == "1.11" ? "1.11/${var.risk}" : "latest/${var.risk}"
  metacontroller_operator_channel = var.release == "1.11" ? "4.11/${var.risk}" : "latest/${var.risk}"
  pvcviewer_operator_channel      = var.release == "1.11" ? "1.11/${var.risk}" : "latest/${var.risk}"

  # KFP Component
  kfp_channel             = var.release == "1.11" ? "2.16/${var.risk}" : "latest/${var.risk}"
  argo_controller_channel = var.release == "1.11" ? "3.7/${var.risk}" : "latest/${var.risk}"
  mlmd_channel            = var.release == "1.11" ? "ckf-1.10/${var.risk}" : "latest/${var.risk}"
  envoy_channel           = var.release == "1.11" ? "2.4/${var.risk}" : "latest/${var.risk}"

  # Standalone Charms
  minio_channel         = var.release == "1.11" ? "1.10/${var.risk}" : "latest/${var.risk}"
  s3_integrator_channel = "2/edge/pr-188"

  # Istio Component (sidecar)
  istio_sidecar_channel = var.release == "1.11" ? "1.28/${var.risk}" : "latest/${var.risk}"

  # Istio Component (ambient gateways + beacon)
  # NOTE: the ambient IAM architecture needs the istio-ingress-route,
  # gateway-metadata and istio-request-auth endpoints, which are currently only
  # published on the `dev/edge` channel of the Istio charms (2/* and 1/* predate
  # them). Move these back to a stable track once those endpoints graduate.
  istio_channel             = local.ambient_iam ? "dev/edge" : "2/stable"
  istio_ingress_k8s_channel = local.istio_channel
  istio_beacon_k8s_channel  = local.istio_channel
  istio_k8s_channel         = local.istio_channel

  # IAM Auth Charms (ambient)
  oauth2_proxy_channel                        = "latest/edge"
  request_authentication_configurator_channel = var.release == "1.11" ? "1.0/edge" : "latest/edge"
  github_profiles_automator_channel           = var.release == "1.11" ? "1.0/edge" : "latest/edge"

  # Katib Component
  katib_channel = var.release == "1.11" ? "0.19/${var.risk}" : "latest/${var.risk}"

  # Notebooks Component
  notebooks_channel = var.release == "1.11" ? "1.11/${var.risk}" : "latest/${var.risk}"

  # Tensorboard Component
  tensorboard_channel = var.release == "1.11" ? "1.11/${var.risk}" : "latest/${var.risk}"

  # Resource Dispatcher Charm
  resource_dispatcher_channel = var.release == "1.11" ? "2.0/${var.risk}" : "latest/${var.risk}"

  # MLflow Component
  mlflow_channel = var.release == "1.11" ? "2.22/${var.risk}" : "latest/${var.risk}"

  # KServe Component
  kserve_channel  = var.release == "1.11" ? "0.17/${var.risk}" : "latest/${var.risk}"
  knative_channel = var.release == "1.11" ? "1.16/${var.risk}" : "latest/${var.risk}"
  deploy_kserve   = var.enable_kserve || var.enable_mlflow
  deploy_mysql    = var.enable_kfp || var.enable_katib || var.enable_mlflow

  # Object storage backend selection ('minio' or 'S3')
  object_storage_consumers = var.enable_kfp || var.enable_mlflow || var.enable_kserve
  deploy_minio             = var.object_storage_mode == "minio" && local.object_storage_consumers
  deploy_s3_integrator     = var.object_storage_mode == "S3" && local.object_storage_consumers

  # Feast Component
  feast_channel = var.release == "1.11" ? "0.49/${var.risk}" : "latest/${var.risk}"

  # Training Component
  training_operator_channel = var.release == "1.11" ? "1.9/${var.risk}" : "latest/${var.risk}"
  kubeflow_trainer_channel  = var.release == "1.11" ? "2.1/edge" : "latest/${var.risk}"

  kubeflow_profiles_service_mesh_config = local.ambient ? {
    "service-mesh-mode"             = "istio-ambient"
    "istio-gateway-service-account" = local.ambient_iam ? "istio-ingress-k8s-ui-istio" : "istio-ingress-k8s-istio"
    } : {
    "service-mesh-mode"             = "istio-sidecar"
    "istio-gateway-service-account" = "istio-ingressgateway-workload-service-account"
  }

  istio_pilot_config = merge(
    var.istio_pilot_config,
    var.istio_cni_bin_dir != "" ? { "cni-bin-dir" = var.istio_cni_bin_dir } : {},
    var.istio_cni_conf_dir != "" ? { "cni-conf-dir" = var.istio_cni_conf_dir } : {}
  )

  argo_controller_config = merge(
    var.argo_controller_config,
    { "bucket" = var.s3_bucket_global }
  )

  kfp_api_config = merge(
    var.kfp_api_config,
    { "object-store-bucket-name" = var.s3_bucket_global }
  )

  kfp_profile_controller_config = merge(
    var.kfp_profile_controller_config,
    { "default-pipeline-root" = "minio://${var.s3_bucket_global}/v2/artifacts" }
  )

  kubeflow_profiles = {
    channel  = local.kubeflow_profiles_channel
    revision = var.kubeflow_profiles_revision
    config   = merge(local.kubeflow_profiles_service_mesh_config, var.kubeflow_profiles_config, { "security-policy" = var.kubeflow_profiles_security_policy })
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
  # Service-mesh + auth mode helpers and gateway/mesh selectors, derived from
  # the two inputs var.service_mesh_type ('sidecar' | 'ambient') and
  # var.auth_type ('dex' | 'iam'). Supported combinations:
  #   sidecar + dex : istio-pilot + istio-ingressgateway; Dex/OIDC auth.
  #   ambient + dex : single gateway + beacon + istio-k8s in-model (component
  #                   istio-ambient-dex); Dex/OIDC auth.
  #   ambient + iam : two gateways (UI/M2M) + beacon (component istio-ambient);
  #                   istio-k8s in istio-system; IAM auth stack.
  # (sidecar + iam is rejected by variable validation.)
  # For ambient_dex the UI and M2M selectors both resolve to the single gateway.
  # ------------------------------------------------------------------
  sidecar     = var.service_mesh_type == "sidecar"
  ambient     = var.service_mesh_type == "ambient"
  ambient_iam = local.ambient && var.auth_type == "iam"
  ambient_dex = local.ambient && var.auth_type == "dex"
  legacy_auth = var.auth_type == "dex"

  ui_istio_ingress_route = local.ambient_iam ? {
    kind     = "endpoint"
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_ui_istio_ingress_route.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_ui_istio_ingress_route.endpoint
    } : local.ambient_dex ? {
    kind     = "endpoint"
    name     = module.ambient_dex[0].provides.istio_ingress_k8s_istio_ingress_route.name
    endpoint = module.ambient_dex[0].provides.istio_ingress_k8s_istio_ingress_route.endpoint
  } : null

  ui_gateway_metadata = local.ambient_iam ? {
    kind     = "endpoint"
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_ui_gateway_metadata.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_ui_gateway_metadata.endpoint
    } : local.ambient_dex ? {
    kind     = "endpoint"
    name     = module.ambient_dex[0].provides.istio_ingress_k8s_gateway_metadata.name
    endpoint = module.ambient_dex[0].provides.istio_ingress_k8s_gateway_metadata.endpoint
  } : null

  m2m_gateway_metadata = local.ambient_iam ? {
    kind     = "endpoint"
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_gateway_metadata.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_gateway_metadata.endpoint
    } : local.ambient_dex ? {
    kind     = "endpoint"
    name     = module.ambient_dex[0].provides.istio_ingress_k8s_gateway_metadata.name
    endpoint = module.ambient_dex[0].provides.istio_ingress_k8s_gateway_metadata.endpoint
  } : null

  # Unauthenticated route on the single gateway, consumed by oidc-gatekeeper on
  # the ambient-dex path.
  istio_ingress_route_unauthenticated = local.ambient_dex ? {
    kind     = "endpoint"
    name     = module.ambient_dex[0].provides.istio_ingress_k8s_istio_ingress_route_unauthenticated.name
    endpoint = module.ambient_dex[0].provides.istio_ingress_k8s_istio_ingress_route_unauthenticated.endpoint
  } : null

  # Beacon service-mesh (bare {name,endpoint}); service_mesh adds kind for the
  # component inputs that expect it.
  beacon = local.ambient_iam ? {
    name     = module.ambient_iam[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient_iam[0].provides.istio_beacon_k8s_service_mesh.endpoint
    } : local.ambient_dex ? {
    name     = module.ambient_dex[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient_dex[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  service_mesh = local.beacon == null ? null : {
    kind     = "endpoint"
    name     = local.beacon.name
    endpoint = local.beacon.endpoint
  }

}


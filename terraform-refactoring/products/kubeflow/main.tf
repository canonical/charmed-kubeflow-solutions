# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "kubeflow" {
  count = var.create_model ? 1 : 0
  name  = "kubeflow"
}

module "istio" {
  count  = var.service_mesh_type == "sidecar" ? 1 : 0
  source = "git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/istio-sidecar?ref=feat/terraform-refactor"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  istio_pilot = {
    channel  = local.istio_sidecar_channel
    revision = var.istio_pilot_revision
    config   = var.istio_pilot_config
  }
  istio_ingressgateway = {
    channel  = local.istio_sidecar_channel
    revision = var.istio_ingressgateway_revision
    config   = var.istio_ingressgateway_config
  }
}

module "ambient" {
  count  = var.service_mesh_type == "ambient" ? 1 : 0
  source = "git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/istio-ambient?ref=feat/terraform-refactor"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  istio_k8s = {
    revision = var.istio_k8s_revision
    config   = merge(var.istio_k8s_config, var.istio_k8s_platform != "" ? { platform = var.istio_k8s_platform } : {})
  }
  istio_ingress_k8s = {
    revision = var.istio_ingress_k8s_revision
    config   = var.istio_ingress_k8s_config
  }
  istio_beacon_k8s = {
    revision = var.istio_beacon_k8s_revision
    config   = var.istio_beacon_k8s_config
  }
}

module "auth" {
  depends_on = [module.istio, module.ambient]

  source = "../../components/auth"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  dex_auth = {
    channel  = local.dex_auth_channel
    revision = var.dex_auth_revision
    config   = var.dex_auth_config
  }
  oidc_gatekeeper = {
    channel  = local.oidc_gatekeeper_channel
    revision = var.oidc_gatekeeper_revision
    config   = var.oidc_gatekeeper_config
  }

  ingress = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  ingress_auth = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress_auth.name
    endpoint = module.istio[0].provides.istio_pilot_ingress_auth.endpoint
  } : null

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  istio_ingress_route_unauthenticated = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route_unauthenticated.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route_unauthenticated.endpoint
  } : null
}

module "core" {
  depends_on = [module.istio, module.ambient, module.auth]

  source = "../../components/core"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  admission_webhook = {
    channel  = local.admission_webhook_channel
    revision = var.admission_webhook_revision
    config   = var.admission_webhook_config
  }
  kubeflow_dashboard = {
    channel  = local.kubeflow_dashboard_channel
    revision = var.kubeflow_dashboard_revision
    config   = var.kubeflow_dashboard_config
  }
  kubeflow_profiles = local.kubeflow_profiles
  kubeflow_roles = {
    channel  = local.kubeflow_roles_channel
    revision = var.kubeflow_roles_revision
    config   = var.kubeflow_roles_config
  }
  kubeflow_volumes = {
    channel  = local.kubeflow_volumes_channel
    revision = var.kubeflow_volumes_revision
    config   = var.kubeflow_volumes_config
  }
  metacontroller_operator = {
    channel  = local.metacontroller_operator_channel
    revision = var.metacontroller_operator_revision
    config   = var.metacontroller_operator_config
  }
  pvcviewer_operator = {
    channel  = local.pvcviewer_operator_channel
    revision = var.pvcviewer_operator_revision
    config   = var.pvcviewer_operator_config
  }

  ingress = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  istio_ingress_route = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.endpoint
  } : null

  gateway_metadata = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_gateway_metadata.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_gateway_metadata.endpoint
  } : null
}

module "minio" {
  count      = local.deploy_minio ? 1 : 0
  depends_on = [module.istio, module.ambient]

  source = "../../charms/minio"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid
  channel    = local.minio_channel
  revision   = var.minio_revision
  config     = var.minio_config
}

module "mysql" {
  count  = local.deploy_mysql ? 1 : 0
  source = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=58072079edc97bace08b6ff9c8f380b94867ebd4"

  model    = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid
  app_name = "mysql-db"
  channel  = "8.0/stable"
  revision = var.mysql.revision
  units    = var.mysql.units
  config = merge(
    { "profile-limit-memory" = "2048" },
    var.mysql.config
  )
  storage_size = var.mysql.storage_size
}

module "katib" {
  count      = var.enable_katib ? 1 : 0
  depends_on = [module.core, module.mysql, module.istio, module.ambient]

  source = "../../components/katib"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  mysql_database = {
    kind     = "endpoint"
    name     = module.mysql[0].app_name
    endpoint = module.mysql[0].provides.database
  }

  dashboard_links = {
    kind     = "endpoint"
    name     = module.core.provides.kubeflow_dashboard_links.name
    endpoint = module.core.provides.kubeflow_dashboard_links.endpoint
  }

  ingress = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  istio_ingress_route = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.endpoint
  } : null

  katib_controller = {
    channel  = local.katib_channel
    revision = var.katib_controller_revision
    config   = var.katib_controller_config
  }

  katib_db_manager = {
    channel  = local.katib_channel
    revision = var.katib_db_manager_revision
    config   = var.katib_db_manager_config
  }

  katib_ui = {
    channel  = local.katib_channel
    revision = var.katib_ui_revision
    config   = var.katib_ui_config
  }
}

module "kfp" {
  count      = var.enable_kfp ? 1 : 0
  depends_on = [module.istio, module.ambient, module.core, module.minio, module.mysql]

  source = "../../components/kfp"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  mysql_database = {
    kind     = "endpoint"
    name     = module.mysql[0].app_name
    endpoint = module.mysql[0].provides.database
  }

  object_storage = {
    kind     = "endpoint"
    name     = module.minio[0].provides.object_storage.name
    endpoint = module.minio[0].provides.object_storage.endpoint
  }

  dashboard_links = {
    kind     = "endpoint"
    name     = module.core.provides.kubeflow_dashboard_links.name
    endpoint = module.core.provides.kubeflow_dashboard_links.endpoint
  }

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  istio_ingress_route = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.endpoint
  } : null

  ingress = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  argo_controller = {
    channel  = local.argo_controller_channel
    revision = var.argo_controller_revision
    config   = var.argo_controller_config
  }
  envoy = {
    channel  = local.envoy_channel
    revision = var.envoy_revision
    config   = var.envoy_config
  }

  mlmd = {
    channel  = local.mlmd_channel
    revision = var.mlmd_revision
    config   = var.mlmd_config
  }

  kfp_api = {
    channel  = local.kfp_channel
    revision = var.kfp_api_revision
    config   = var.kfp_api_config
  }

  kfp_metadata_writer = {
    channel  = local.kfp_channel
    revision = var.kfp_metadata_writer_revision
    config   = var.kfp_metadata_writer_config
  }

  kfp_persistence = {
    channel  = local.kfp_channel
    revision = var.kfp_persistence_revision
    config   = var.kfp_persistence_config
  }

  kfp_profile_controller = {
    channel  = local.kfp_channel
    revision = var.kfp_profile_controller_revision
    config   = var.kfp_profile_controller_config
  }

  kfp_schedwf = {
    channel  = local.kfp_channel
    revision = var.kfp_schedwf_revision
    config   = var.kfp_schedwf_config
  }

  kfp_ui = {
    channel  = local.kfp_channel
    revision = var.kfp_ui_revision
    config   = var.kfp_ui_config
  }

  kfp_viewer = {
    channel  = local.kfp_channel
    revision = var.kfp_viewer_revision
    config   = var.kfp_viewer_config
  }

  kfp_viz = {
    channel  = local.kfp_channel
    revision = var.kfp_viz_revision
    config   = var.kfp_viz_config
  }
}

module "notebooks" {
  count      = var.enable_notebooks ? 1 : 0
  depends_on = [module.core, module.istio, module.ambient]

  source = "../../components/notebooks"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  dashboard_links = {
    kind     = "endpoint"
    name     = module.core.provides.kubeflow_dashboard_links.name
    endpoint = module.core.provides.kubeflow_dashboard_links.endpoint
  }

  ingress = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  gateway_metadata = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_gateway_metadata.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_gateway_metadata.endpoint
  } : null

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  istio_ingress_route = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.endpoint
  } : null

  jupyter_controller = {
    channel  = local.notebooks_channel
    revision = var.jupyter_controller_revision
    config   = var.jupyter_controller_config
  }

  jupyter_ui = {
    channel  = local.notebooks_channel
    revision = var.jupyter_ui_revision
    config   = var.jupyter_ui_config
  }
}

module "tensorboard" {
  count      = var.enable_tensorboard ? 1 : 0
  depends_on = [module.core, module.istio, module.ambient]

  source = "../../components/tensorboard"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  dashboard_links = {
    kind     = "endpoint"
    name     = module.core.provides.kubeflow_dashboard_links.name
    endpoint = module.core.provides.kubeflow_dashboard_links.endpoint
  }

  gateway_info = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_gateway_info.name
    endpoint = module.istio[0].provides.istio_pilot_gateway_info.endpoint
  } : null

  ingress = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  gateway_metadata = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_gateway_metadata.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_gateway_metadata.endpoint
  } : null

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  istio_ingress_route = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.endpoint
  } : null

  tensorboard_controller = {
    channel  = local.tensorboard_channel
    revision = var.tensorboard_controller_revision
    config   = var.tensorboard_controller_config
  }

  tensorboards_web_app = {
    channel  = local.tensorboard_channel
    revision = var.tensorboards_web_app_revision
    config   = var.tensorboards_web_app_config
  }
}

module "resource_dispatcher" {
  count      = (var.enable_mlflow || var.enable_feast) ? 1 : 0
  depends_on = [module.istio, module.ambient]

  source = "../../charms/resource-dispatcher"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid
  channel    = local.resource_dispatcher_channel
  revision   = var.resource_dispatcher_revision
  config     = var.resource_dispatcher_config
}

module "mlflow" {
  count      = var.enable_mlflow ? 1 : 0
  depends_on = [module.istio, module.ambient, module.core, module.minio, module.mysql, module.resource_dispatcher]

  source = "../../components/mlflow"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  dashboard_links = {
    kind     = "endpoint"
    name     = module.core.provides.kubeflow_dashboard_links.name
    endpoint = module.core.provides.kubeflow_dashboard_links.endpoint
  }

  mysql_database = {
    kind     = "endpoint"
    name     = module.mysql[0].app_name
    endpoint = module.mysql[0].provides.database
  }

  object_storage = {
    kind     = "endpoint"
    name     = module.minio[0].provides.object_storage.name
    endpoint = module.minio[0].provides.object_storage.endpoint
  }

  secrets = {
    kind     = "endpoint"
    name     = module.resource_dispatcher[0].provides.secrets.name
    endpoint = module.resource_dispatcher[0].provides.secrets.endpoint
  }

  pod_defaults = {
    kind     = "endpoint"
    name     = module.resource_dispatcher[0].provides.pod_defaults.name
    endpoint = module.resource_dispatcher[0].provides.pod_defaults.endpoint
  }

  ingress = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  istio_ingress_route = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.endpoint
  } : null

  mlflow_server = {
    channel  = local.mlflow_channel
    revision = var.mlflow_server_revision
    config   = var.mlflow_server_config
  }
}

module "kserve" {
  count      = local.deploy_kserve ? 1 : 0
  depends_on = [module.istio, module.ambient]

  source = "../../components/kserve"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  gateway_info = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_gateway_info.name
    endpoint = module.istio[0].provides.istio_pilot_gateway_info.endpoint
  } : null

  gateway_metadata = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_gateway_metadata.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_gateway_metadata.endpoint
  } : null

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  kserve_controller = {
    channel  = local.kserve_channel
    revision = var.kserve_controller_revision
    config = merge({
      "deployment-mode" = var.service_mesh_type == "sidecar" ? "knative" : "standard"
    }, var.kserve_controller_config)
  }

  knative_operator = {
    channel  = local.knative_channel
    revision = var.knative_operator_revision
    config   = var.knative_operator_config
  }

  knative_serving = {
    channel  = local.knative_channel
    revision = var.knative_serving_revision
    config = merge({
      "istio.gateway.namespace" = var.create_model ? juju_model.kubeflow[0].name : "kubeflow"
      "istio.gateway.name"      = "kubeflow-gateway"
    }, var.knative_serving_config)
  }

  knative_eventing = {
    channel  = local.knative_channel
    revision = var.knative_eventing_revision
    config   = var.knative_eventing_config
  }
}

module "training" {
  count      = (var.enable_training_v1 || var.enable_training_v2) ? 1 : 0
  depends_on = [module.core, module.istio, module.ambient]

  source = "../../components/training"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  enable_v1 = var.enable_training_v1
  enable_v2 = var.enable_training_v2

  dashboard_links = {
    kind     = "endpoint"
    name     = module.core.provides.kubeflow_dashboard_links.name
    endpoint = module.core.provides.kubeflow_dashboard_links.endpoint
  }

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  training_operator = {
    channel  = local.training_operator_channel
    revision = var.training_operator_revision
    config   = var.training_operator_config
  }

  kubeflow_trainer = {
    channel  = local.kubeflow_trainer_channel
    revision = var.kubeflow_trainer_revision
    config   = var.kubeflow_trainer_config
  }
}

module "postgresql_k8s" {
  count      = var.enable_feast ? 1 : 0
  depends_on = [module.istio, module.ambient]

  source = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=b7822d93f8d5d0d94ca3da36ea9f5b13f3e58d43"

  model_uuid         = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid
  app_name           = "postgresql-k8s"
  channel            = "14/stable"
  revision           = var.postgresql_k8s.revision
  units              = var.postgresql_k8s.units
  storage_directives = var.postgresql_k8s.storage_directives
  config             = var.postgresql_k8s.config
}

module "feast" {
  count      = var.enable_feast ? 1 : 0
  depends_on = [module.istio, module.ambient, module.core, module.resource_dispatcher, module.postgresql_k8s]

  source = "../../components/feast"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  offline_store = {
    kind     = "endpoint"
    name     = module.postgresql_k8s[0].app_name
    endpoint = module.postgresql_k8s[0].provides.database
  }

  online_store = {
    kind     = "endpoint"
    name     = module.postgresql_k8s[0].app_name
    endpoint = module.postgresql_k8s[0].provides.database
  }

  registry = {
    kind     = "endpoint"
    name     = module.postgresql_k8s[0].app_name
    endpoint = module.postgresql_k8s[0].provides.database
  }

  secrets = {
    kind     = "endpoint"
    name     = module.resource_dispatcher[0].provides.secrets.name
    endpoint = module.resource_dispatcher[0].provides.secrets.endpoint
  }

  pod_defaults = {
    kind     = "endpoint"
    name     = module.resource_dispatcher[0].provides.pod_defaults.name
    endpoint = module.resource_dispatcher[0].provides.pod_defaults.endpoint
  }

  dashboard_links = {
    kind     = "endpoint"
    name     = module.core.provides.kubeflow_dashboard_links.name
    endpoint = module.core.provides.kubeflow_dashboard_links.endpoint
  }

  ingress = var.service_mesh_type == "sidecar" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  istio_ingress_route = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.name
    endpoint = module.ambient[0].provides.istio_ingress_k8s_istio_ingress_route.endpoint
  } : null

  service_mesh = var.service_mesh_type == "ambient" ? {
    kind     = "endpoint"
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  feast_integrator = {
    channel  = local.feast_channel
    revision = var.feast_integrator_revision
    config   = var.feast_integrator_config
  }

  feast_ui = {
    channel  = local.feast_channel
    revision = var.feast_ui_revision
    config   = var.feast_ui_config
  }
}

module "observability" {
  count = var.enable_observability ? 1 : 0
  depends_on = [
    module.auth, module.core, module.istio, module.ambient,
    module.kfp, module.katib, module.kserve, module.notebooks,
    module.tensorboard, module.training, module.mlflow, module.minio,
  ]

  source = "../../components/observability"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  dashboards_offer = var.dashboards_offer
  logging_offer    = var.logging_offer
  metrics_offer    = var.metrics_offer

  opentelemetry_collector_k8s = var.opentelemetry_collector_k8s

  # Core
  kubeflow_dashboard_grafana_dashboard      = module.core.provides.kubeflow_dashboard_grafana_dashboard
  kubeflow_dashboard_metrics_endpoint       = module.core.provides.kubeflow_dashboard_metrics_endpoint
  kubeflow_profiles_metrics_endpoint        = module.core.provides.kubeflow_profiles_metrics_endpoint
  metacontroller_operator_grafana_dashboard = module.core.provides.metacontroller_operator_grafana_dashboard
  metacontroller_operator_metrics_endpoint  = module.core.provides.metacontroller_operator_metrics_endpoint
  pvcviewer_operator_grafana_dashboard      = module.core.provides.pvcviewer_operator_grafana_dashboard
  pvcviewer_operator_metrics_endpoint       = module.core.provides.pvcviewer_operator_metrics_endpoint
  admission_webhook_logging                 = module.core.requires.admission_webhook_logging
  kubeflow_dashboard_logging                = module.core.requires.kubeflow_dashboard_logging
  kubeflow_profiles_logging                 = module.core.requires.kubeflow_profiles_logging
  kubeflow_volumes_logging                  = module.core.requires.kubeflow_volumes_logging
  pvcviewer_operator_logging                = module.core.requires.pvcviewer_operator_logging

  # Auth
  dex_auth_grafana_dashboard = module.auth.provides.dex_auth_grafana_dashboard
  dex_auth_metrics_endpoint  = module.auth.provides.dex_auth_metrics_endpoint
  dex_auth_logging           = module.auth.requires.dex_auth_logging
  oidc_gatekeeper_logging    = module.auth.requires.oidc_gatekeeper_logging

  # KFP
  argo_controller_grafana_dashboard = var.enable_kfp ? module.kfp[0].provides.argo_controller_grafana_dashboard : null
  argo_controller_metrics_endpoint  = var.enable_kfp ? module.kfp[0].provides.argo_controller_metrics_endpoint : null
  envoy_grafana_dashboard           = var.enable_kfp ? module.kfp[0].provides.envoy_grafana_dashboard : null
  envoy_metrics_endpoint            = var.enable_kfp ? module.kfp[0].provides.envoy_metrics_endpoint : null
  kfp_api_grafana_dashboard         = var.enable_kfp ? module.kfp[0].provides.kfp_api_grafana_dashboard : null
  kfp_api_metrics_endpoint          = var.enable_kfp ? module.kfp[0].provides.kfp_api_metrics_endpoint : null
  argo_controller_logging           = var.enable_kfp ? module.kfp[0].requires.argo_controller_logging : null
  envoy_logging                     = var.enable_kfp ? module.kfp[0].requires.envoy_logging : null
  kfp_api_logging                   = var.enable_kfp ? module.kfp[0].requires.kfp_api_logging : null
  kfp_metadata_writer_logging       = var.enable_kfp ? module.kfp[0].requires.kfp_metadata_writer_logging : null
  kfp_persistence_logging           = var.enable_kfp ? module.kfp[0].requires.kfp_persistence_logging : null
  kfp_profile_controller_logging    = var.enable_kfp ? module.kfp[0].requires.kfp_profile_controller_logging : null
  kfp_schedwf_logging               = var.enable_kfp ? module.kfp[0].requires.kfp_schedwf_logging : null
  kfp_ui_logging                    = var.enable_kfp ? module.kfp[0].requires.kfp_ui_logging : null
  kfp_viewer_logging                = var.enable_kfp ? module.kfp[0].requires.kfp_viewer_logging : null
  kfp_viz_logging                   = var.enable_kfp ? module.kfp[0].requires.kfp_viz_logging : null
  mlmd_logging                      = var.enable_kfp ? module.kfp[0].requires.mlmd_logging : null

  # Katib
  katib_controller_grafana_dashboard = var.enable_katib ? module.katib[0].provides.katib_controller_grafana_dashboard : null
  katib_controller_metrics_endpoint  = var.enable_katib ? module.katib[0].provides.katib_controller_metrics_endpoint : null
  katib_controller_logging           = var.enable_katib ? module.katib[0].requires.katib_controller_logging : null
  katib_db_manager_logging           = var.enable_katib ? module.katib[0].requires.katib_db_manager_logging : null
  katib_ui_logging                   = var.enable_katib ? module.katib[0].requires.katib_ui_logging : null

  # KServe
  kserve_controller_metrics_endpoint = local.deploy_kserve ? module.kserve[0].provides.kserve_controller_metrics_endpoint : null
  knative_operator_metrics_endpoint  = local.deploy_kserve ? try(module.kserve[0].provides.knative_operator_metrics_endpoint, null) : null
  kserve_controller_logging          = local.deploy_kserve ? module.kserve[0].requires.kserve_controller_logging : null
  knative_operator_logging           = local.deploy_kserve ? try(module.kserve[0].requires.knative_operator_logging, null) : null

  # Notebooks
  jupyter_controller_grafana_dashboard = var.enable_notebooks ? module.notebooks[0].provides.jupyter_controller_grafana_dashboard : null
  jupyter_controller_metrics_endpoint  = var.enable_notebooks ? module.notebooks[0].provides.jupyter_controller_metrics_endpoint : null
  jupyter_controller_logging           = var.enable_notebooks ? module.notebooks[0].requires.jupyter_controller_logging : null
  jupyter_ui_logging                   = var.enable_notebooks ? module.notebooks[0].requires.jupyter_ui_logging : null

  # Training
  training_operator_grafana_dashboard = (var.enable_training_v1 || var.enable_training_v2) ? try(module.training[0].provides.training_operator_grafana_dashboard, null) : null
  training_operator_metrics_endpoint  = (var.enable_training_v1 || var.enable_training_v2) ? try(module.training[0].provides.training_operator_metrics_endpoint, null) : null
  kubeflow_trainer_grafana_dashboard  = (var.enable_training_v1 || var.enable_training_v2) ? try(module.training[0].provides.kubeflow_trainer_grafana_dashboard, null) : null
  kubeflow_trainer_metrics_endpoint   = (var.enable_training_v1 || var.enable_training_v2) ? try(module.training[0].provides.kubeflow_trainer_metrics_endpoint, null) : null

  # Tensorboard
  tensorboard_controller_metrics_endpoint = var.enable_tensorboard ? module.tensorboard[0].provides.tensorboard_controller_metrics_endpoint : null
  tensorboard_controller_logging          = var.enable_tensorboard ? module.tensorboard[0].requires.tensorboard_controller_logging : null
  tensorboards_web_app_logging            = var.enable_tensorboard ? module.tensorboard[0].requires.tensorboards_web_app_logging : null

  # Istio Sidecar
  istio_ingressgateway_metrics_endpoint = var.service_mesh_type == "sidecar" ? module.istio[0].provides.istio_ingressgateway_metrics_endpoint : null
  istio_pilot_grafana_dashboard         = var.service_mesh_type == "sidecar" ? module.istio[0].provides.istio_pilot_grafana_dashboard : null
  istio_pilot_metrics_endpoint          = var.service_mesh_type == "sidecar" ? module.istio[0].provides.istio_pilot_metrics_endpoint : null

  # Minio
  minio_grafana_dashboard = local.deploy_minio ? module.minio[0].provides.grafana_dashboard : null
  minio_metrics_endpoint  = local.deploy_minio ? module.minio[0].provides.metrics_endpoint : null

  # Service mesh (ambient only)
  service_mesh = var.service_mesh_type == "ambient" ? {
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  } : null

  # MLflow
  mlflow_server_grafana_dashboard = var.enable_mlflow ? module.mlflow[0].provides.mlflow_server_grafana_dashboard : null
  mlflow_server_metrics_endpoint  = var.enable_mlflow ? module.mlflow[0].provides.mlflow_server_metrics_endpoint : null
  mlflow_server_logging           = var.enable_mlflow ? module.mlflow[0].requires.mlflow_server_logging : null
}
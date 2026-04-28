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

  source = "git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/auth?ref=feat/terraform-refactor"

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

  source = "git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/core?ref=feat/terraform-refactor"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

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
  depends_on = [module.istio, module.ambient]

  source = "git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/charms/minio?ref=feat/terraform-refactor"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid
  channel    = local.minio_channel
  revision   = var.minio_revision
  config     = var.minio_config
}

module "mysql" {
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

  source = "git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/katib?ref=feat/terraform-refactor"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  mysql_database = {
    kind     = "endpoint"
    name     = module.mysql.app_name
    endpoint = module.mysql.provides.database
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

  source = "git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/kfp?ref=feat/terraform-refactor"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  mysql_database = {
    kind     = "endpoint"
    name     = module.mysql.app_name
    endpoint = module.mysql.provides.database
  }

  object_storage = {
    kind     = "endpoint"
    name     = module.minio.provides.object_storage.name
    endpoint = module.minio.provides.object_storage.endpoint
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
  count      = var.enable_mlflow ? 1 : 0
  depends_on = [module.istio, module.ambient]

  source = "../../charms/resource-dispatcher"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid
  channel    = local.resource_dispatcher_channel
  revision   = var.resource_dispatcher_revision
  config     = var.resource_dispatcher_config
}

module "mlflow" {
  count      = var.enable_mlflow ? 1 : 0
  depends_on = [module.istio, module.ambient, module.minio]

  source = "../../components/mlflow"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  object_storage = {
    kind     = "endpoint"
    name     = module.minio.provides.object_storage.name
    endpoint = module.minio.provides.object_storage.endpoint
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

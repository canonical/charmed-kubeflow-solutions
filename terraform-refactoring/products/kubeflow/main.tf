# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "kubeflow" {
  count = var.create_model ? 1 : 0
  name  = "kubeflow"
}

module "istio" {
  count  = var.service_mesh_type == "istio" ? 1 : 0
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

  ingress = var.service_mesh_type == "istio" ? {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  } : null

  ingress_auth = var.service_mesh_type == "istio" ? {
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

  ingress = var.service_mesh_type == "istio" ? {
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
}

module "minio" {
  depends_on = [module.istio, module.ambient]

  source = "../../charms/minio"

  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid
  channel    = local.minio_channel
  revision   = var.minio_revision
  config     = var.minio_config
}

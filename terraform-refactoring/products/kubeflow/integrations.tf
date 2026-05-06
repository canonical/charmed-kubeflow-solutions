# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Most cross-component integrations are handled by passing outputs from the
# istio/ambient modules as inputs to downstream component modules.
# See main.tf for the wiring of service_mesh, istio_ingress_route, and
# istio_ingress_route_unauthenticated into module "core".

# forward-auth: oidc-gatekeeper (core) -> istio-ingress-k8s (ambient)
# This cannot be passed through module variables without creating a cycle,
# since module.core already references module.ambient outputs.
resource "juju_integration" "oidc_gatekeeper_istio_ingress_k8s_forward_auth" {
  count      = var.service_mesh_type == "ambient" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.auth.provides.oidc_gatekeeper_forward_auth.name
    endpoint = module.auth.provides.oidc_gatekeeper_forward_auth.endpoint
  }

  application {
    name     = module.ambient[0].requires.istio_ingress_k8s_forward_auth.name
    endpoint = module.ambient[0].requires.istio_ingress_k8s_forward_auth.endpoint
  }
}

# minio service-mesh integration (ambient only)
resource "juju_integration" "minio_service_mesh" {
  count      = var.service_mesh_type == "ambient" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.minio[0].requires.service_mesh.name
    endpoint = module.minio[0].requires.service_mesh.endpoint
  }

  application {
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  }
}

# kserve-controller object-storage integration (minio:object-storage -> kserve-controller)
# Only deployed when MLflow is enabled, since kserve uses minio to read MLflow model artifacts
resource "juju_integration" "kserve_controller_object_storage" {
  count      = (var.enable_mlflow && var.enable_kserve) ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.kserve[0].requires.kserve_controller_object_storage.name
    endpoint = module.kserve[0].requires.kserve_controller_object_storage.endpoint
  }

  application {
    name     = module.minio[0].provides.object_storage.name
    endpoint = module.minio[0].provides.object_storage.endpoint
  }
}

# resource-dispatcher service-mesh integration (ambient only)
resource "juju_integration" "resource_dispatcher_service_mesh" {
  count      = ((var.enable_mlflow || var.enable_feast) && var.service_mesh_type == "ambient") ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.resource_dispatcher[0].requires.service_mesh.name
    endpoint = module.resource_dispatcher[0].requires.service_mesh.endpoint
  }

  application {
    name     = module.ambient[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient[0].provides.istio_beacon_k8s_service_mesh.endpoint
  }
}

# kserve-controller secrets integration (resource-dispatcher:secrets -> kserve-controller)
# Only deployed when MLflow is enabled
resource "juju_integration" "kserve_controller_secrets" {
  count      = var.enable_mlflow ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.kserve[0].requires.kserve_controller_secrets.name
    endpoint = module.kserve[0].requires.kserve_controller_secrets.endpoint
  }

  application {
    name     = module.resource_dispatcher[0].provides.secrets.name
    endpoint = module.resource_dispatcher[0].provides.secrets.endpoint
  }
}

# kserve-controller service-accounts integration (resource-dispatcher:pod-defaults -> kserve-controller:service-accounts)
# Only deployed when MLflow is enabled
resource "juju_integration" "kserve_controller_service_accounts" {
  count      = var.enable_mlflow ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.kserve[0].requires.kserve_controller_service_accounts.name
    endpoint = module.kserve[0].requires.kserve_controller_service_accounts.endpoint
  }

  application {
    name     = module.resource_dispatcher[0].provides.pod_defaults.name
    endpoint = module.resource_dispatcher[0].provides.pod_defaults.endpoint
  }
}

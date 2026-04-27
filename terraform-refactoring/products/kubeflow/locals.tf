# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  # Auth Component
  dex_auth_channel        = "latest/${var.risk}"
  oidc_gatekeeper_channel = "latest/${var.risk}"

  # Core Component
  kubeflow_dashboard_channel      = "latest/${var.risk}"
  kubeflow_profiles_channel       = "latest/${var.risk}"
  kubeflow_roles_channel          = "latest/${var.risk}"
  kubeflow_volumes_channel        = "latest/${var.risk}"
  metacontroller_operator_channel = "latest/${var.risk}"
  pvcviewer_operator_channel      = "latest/${var.risk}"

  # KFP Component
  kfp_channel             = "latest/${var.risk}"
  argo_controller_channel = "latest/${var.risk}"
  mlmd_channel            = "latest/${var.risk}"
  envoy_channel           = "latest/${var.risk}"

  # Standalone Charms
  minio_channel = "latest/${var.risk}"

  # Istio Component (sidecar)
  istio_sidecar_channel = "1.28/${var.risk}"

  # Katib Component
  katib_channel = "latest/${var.risk}"

  # Notebooks Component
  notebooks_channel = "latest/${var.risk}"

  # Tensorboard Component
  tensorboard_channel = "latest/${var.risk}"

  kubeflow_profiles_service_mesh_config = var.service_mesh_type == "ambient" ? {
    "service-mesh-mode"             = "istio-ambient"
    "istio-gateway-service-account" = "istio-ingress-k8s-istio"
    } : {
    "service-mesh-mode"             = "istio-sidecar"
    "istio-gateway-service-account" = "istio-ingressgateway-workload-service-account"
  }

  kubeflow_profiles = {
    channel  = local.kubeflow_profiles_channel
    revision = var.kubeflow_profiles_revision
    config   = merge(local.kubeflow_profiles_service_mesh_config, var.kubeflow_profiles_config)
  }
}

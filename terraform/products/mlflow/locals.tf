# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  # Standalone Charms
  s3_integrator_channel = "2/edge"

  # Istio Component (ambient gateways + beacon)
  # NOTE: the ambient IAM architecture needs the istio-ingress-route,
  # gateway-metadata and istio-request-auth endpoints, which are currently only
  # published on the `dev/edge` channel of the Istio charms (2/* and 1/* predate
  # them). Move these back to a stable track once those endpoints graduate.
  istio_channel             = "dev/edge"
  istio_ingress_k8s_channel = local.istio_channel
  istio_beacon_k8s_channel  = local.istio_channel

  # IAM Auth Charms (ambient)
  oauth2_proxy_channel                        = "latest/edge"
  request_authentication_configurator_channel = var.release == "1.11" ? "1.0/edge" : "latest/edge"

  # MLflow Component
  # NOTE: the risk is forced to `edge` for the track `latest` as MLflow 3.15 is available only
  # on `latest/edge` so far, while changing risk on `latest` would end up deploying MLflow 2.22
  # TODO: parametrize the risk as soon as MLflow 3 is promoted, for the track `latest` here
  # TODO: restore `"latest/edge"` instead of `"latest/edge/pr-490"` once multi-tenancy is merged
  mlflow_channel = var.release == "1.11" ? "2.22/${var.risk}" : "latest/edge/pr-490"

  ui_istio_ingress_route = {
    kind     = "endpoint"
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_ui_istio_ingress_route.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_ui_istio_ingress_route.endpoint
  }

  # Beacon service-mesh (bare {name,endpoint}); service_mesh adds kind for the
  # component inputs that expect it.
  beacon = {
    name     = module.ambient_iam[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient_iam[0].provides.istio_beacon_k8s_service_mesh.endpoint
  }

  service_mesh = local.beacon == null ? null : {
    kind     = "endpoint"
    name     = local.beacon.name
    endpoint = local.beacon.endpoint
  }

}


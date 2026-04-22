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

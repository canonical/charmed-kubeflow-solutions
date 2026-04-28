# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# KServe Controller gateway-info integration - sidecar (istio-pilot:gateway-info -> kserve-controller)
resource "juju_integration" "kserve_controller_gateway_info" {
  count      = var.gateway_info != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kserve_controller.name
    endpoint = "ingress-gateway"
  }

  application {
    name      = var.gateway_info.kind == "endpoint" ? var.gateway_info.name : null
    endpoint  = var.gateway_info.kind == "endpoint" ? var.gateway_info.endpoint : null
    offer_url = var.gateway_info.kind == "offer" ? var.gateway_info.url : null
  }
}

# KServe Controller local-gateway integration - intra-component (knative-serving:local-gateway -> kserve-controller)
resource "juju_integration" "kserve_controller_knative_serving_local_gateway" {
  count      = var.gateway_info != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kserve_controller.name
    endpoint = "local-gateway"
  }

  application {
    name     = juju_application.knative_serving[0].name
    endpoint = "local-gateway"
  }
}

# KServe Controller gateway-metadata integration - ambient (istio-ingress-k8s:gateway-metadata -> kserve-controller)
resource "juju_integration" "kserve_controller_gateway_metadata" {
  count      = var.gateway_metadata != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kserve_controller.name
    endpoint = "gateway-metadata"
  }

  application {
    name      = var.gateway_metadata.kind == "endpoint" ? var.gateway_metadata.name : null
    endpoint  = var.gateway_metadata.kind == "endpoint" ? var.gateway_metadata.endpoint : null
    offer_url = var.gateway_metadata.kind == "offer" ? var.gateway_metadata.url : null
  }
}

# KServe Controller service-mesh integration - ambient (istio-beacon-k8s:service-mesh -> kserve-controller)
resource "juju_integration" "kserve_controller_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kserve_controller.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

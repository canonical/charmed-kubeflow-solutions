# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Tensorboards Web App dashboard-links integration (kubeflow-dashboard:links -> tensorboards-web-app)
resource "juju_integration" "tensorboards_web_app_dashboard_links" {
  count      = var.dashboard_links != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.tensorboards_web_app.name
    endpoint = "dashboard-links"
  }

  application {
    name      = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.name : null
    endpoint  = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.endpoint : null
    offer_url = var.dashboard_links.kind == "offer" ? var.dashboard_links.url : null
  }
}

# Tensorboards Web App ingress integration - sidecar (istio-pilot:ingress -> tensorboards-web-app)
resource "juju_integration" "tensorboards_web_app_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.tensorboards_web_app.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# Tensorboard Controller gateway-info integration - sidecar (istio-pilot:gateway-info -> tensorboard-controller)
resource "juju_integration" "tensorboard_controller_gateway_info" {
  count      = var.gateway_info != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.tensorboard_controller.name
    endpoint = "gateway-info"
  }

  application {
    name      = var.gateway_info.kind == "endpoint" ? var.gateway_info.name : null
    endpoint  = var.gateway_info.kind == "endpoint" ? var.gateway_info.endpoint : null
    offer_url = var.gateway_info.kind == "offer" ? var.gateway_info.url : null
  }
}

# Tensorboard Controller gateway-metadata integration - ambient (istio-ingress-k8s:gateway-metadata -> tensorboard-controller)
resource "juju_integration" "tensorboard_controller_gateway_metadata" {
  count      = var.gateway_metadata != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.tensorboard_controller.name
    endpoint = "gateway-metadata"
  }

  application {
    name      = var.gateway_metadata.kind == "endpoint" ? var.gateway_metadata.name : null
    endpoint  = var.gateway_metadata.kind == "endpoint" ? var.gateway_metadata.endpoint : null
    offer_url = var.gateway_metadata.kind == "offer" ? var.gateway_metadata.url : null
  }
}

# Tensorboards Web App istio-ingress-route integration - ambient (istio-ingress-k8s:istio-ingress-route -> tensorboards-web-app)
resource "juju_integration" "tensorboards_web_app_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.tensorboards_web_app.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}

# Ambient service-mesh integrations (istio-beacon-k8s:service-mesh -> Tensorboard apps)

resource "juju_integration" "tensorboard_controller_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.tensorboard_controller.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "tensorboards_web_app_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.tensorboards_web_app.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Notebook Web App dashboard-links integration (kubeflow-dashboard:links -> jupyter-ui)
resource "juju_integration" "jupyter_ui_dashboard_links" {
  count      = var.dashboard_links != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.jupyter_ui.name
    endpoint = "dashboard-links"
  }

  application {
    name      = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.name : null
    endpoint  = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.endpoint : null
    offer_url = var.dashboard_links.kind == "offer" ? var.dashboard_links.url : null
  }
}

# Notebook Web App ingress integration - sidecar (istio-pilot:ingress -> jupyter-ui)
resource "juju_integration" "jupyter_ui_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.jupyter_ui.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# Notebook Web App istio-ingress-route integration - ambient (istio-ingress-k8s:istio-ingress-route -> jupyter-ui)
resource "juju_integration" "notebook_web_app_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.jupyter_ui.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}

# Jupyter Controller gateway-metadata integration - ambient (istio-ingress-k8s:gateway-metadata -> jupyter-controller)
resource "juju_integration" "jupyter_controller_gateway_metadata" {
  count      = var.gateway_metadata != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.jupyter_controller.name
    endpoint = "gateway-metadata"
  }

  application {
    name      = var.gateway_metadata.kind == "endpoint" ? var.gateway_metadata.name : null
    endpoint  = var.gateway_metadata.kind == "endpoint" ? var.gateway_metadata.endpoint : null
    offer_url = var.gateway_metadata.kind == "offer" ? var.gateway_metadata.url : null
  }
}

# Ambient service-mesh integrations (istio-beacon-k8s:service-mesh -> Notebooks apps)

resource "juju_integration" "jupyter-controller_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.jupyter_controller.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "jupyter_ui_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.jupyter_ui.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

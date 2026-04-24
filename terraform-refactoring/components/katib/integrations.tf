# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Katib DB Manager to Katib Controller k8s-service-info integration (intra-component)
resource "juju_integration" "katib_db_manager_katib_controller_k8s_service_info" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.katib_db_manager.name
    endpoint = "k8s-service-info"
  }

  application {
    name     = juju_application.katib_controller.name
    endpoint = "k8s-service-info"
  }
}

# Katib DB Manager to MySQL database integration (cross-component)
# Supports both endpoint and offer kinds
resource "juju_integration" "katib_db_manager_mysql_database" {
  count      = var.mysql_database != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.katib_db_manager.name
    endpoint = "relational-db"
  }

  application {
    name      = var.mysql_database.kind == "endpoint" ? var.mysql_database.name : null
    endpoint  = var.mysql_database.kind == "endpoint" ? var.mysql_database.endpoint : null
    offer_url = var.mysql_database.kind == "offer" ? var.mysql_database.url : null
  }
}

# Katib UI dashboard-links integration (kubeflow-dashboard:links -> katib-ui)
resource "juju_integration" "katib_ui_dashboard_links" {
  count      = var.dashboard_links != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.katib_ui.name
    endpoint = "dashboard-links"
  }

  application {
    name      = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.name : null
    endpoint  = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.endpoint : null
    offer_url = var.dashboard_links.kind == "offer" ? var.dashboard_links.url : null
  }
}

# Katib UI ingress integration - sidecar (istio-pilot:ingress -> katib-ui)
resource "juju_integration" "katib_ui_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.katib_ui.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# Katib UI istio-ingress-route integration - ambient (istio-ingress-k8s:istio-ingress-route -> katib-ui)
resource "juju_integration" "katib_ui_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.katib_ui.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}

# Ambient service-mesh integrations (istio-beacon-k8s:service-mesh -> Katib apps)

resource "juju_integration" "katib_controller_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.katib_controller.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "katib_db_manager_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.katib_db_manager.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "katib_ui_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.katib_ui.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

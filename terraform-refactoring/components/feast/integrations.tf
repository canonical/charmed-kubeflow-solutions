# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Feast UI to Feast Integrator feast-configuration integration (intra-component)
resource "juju_integration" "feast_ui_feast_integrator_feast_configuration" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_ui.name
    endpoint = "feast-configuration"
  }

  application {
    name     = juju_application.feast_integrator.name
    endpoint = "feast-configuration"
  }
}

# Feast Integrator offline-store integration (postgresql-k8s:database -> feast-integrator)
resource "juju_integration" "feast_integrator_offline_store" {
  count      = var.offline_store != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_integrator.name
    endpoint = "offline-store"
  }

  application {
    name      = var.offline_store.kind == "endpoint" ? var.offline_store.name : null
    endpoint  = var.offline_store.kind == "endpoint" ? var.offline_store.endpoint : null
    offer_url = var.offline_store.kind == "offer" ? var.offline_store.url : null
  }
}

# Feast Integrator online-store integration (postgresql-k8s:database -> feast-integrator)
resource "juju_integration" "feast_integrator_online_store" {
  count      = var.online_store != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_integrator.name
    endpoint = "online-store"
  }

  application {
    name      = var.online_store.kind == "endpoint" ? var.online_store.name : null
    endpoint  = var.online_store.kind == "endpoint" ? var.online_store.endpoint : null
    offer_url = var.online_store.kind == "offer" ? var.online_store.url : null
  }
}

# Feast Integrator registry integration (postgresql-k8s:database -> feast-integrator)
resource "juju_integration" "feast_integrator_registry" {
  count      = var.registry != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_integrator.name
    endpoint = "registry"
  }

  application {
    name      = var.registry.kind == "endpoint" ? var.registry.name : null
    endpoint  = var.registry.kind == "endpoint" ? var.registry.endpoint : null
    offer_url = var.registry.kind == "offer" ? var.registry.url : null
  }
}

# Feast Integrator secrets integration (resource-dispatcher:secrets -> feast-integrator)
resource "juju_integration" "feast_integrator_secrets" {
  count      = var.secrets != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_integrator.name
    endpoint = "secrets"
  }

  application {
    name      = var.secrets.kind == "endpoint" ? var.secrets.name : null
    endpoint  = var.secrets.kind == "endpoint" ? var.secrets.endpoint : null
    offer_url = var.secrets.kind == "offer" ? var.secrets.url : null
  }
}

# Feast Integrator pod-defaults integration (resource-dispatcher:pod-defaults -> feast-integrator)
resource "juju_integration" "feast_integrator_pod_defaults" {
  count      = var.pod_defaults != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_integrator.name
    endpoint = "pod-defaults"
  }

  application {
    name      = var.pod_defaults.kind == "endpoint" ? var.pod_defaults.name : null
    endpoint  = var.pod_defaults.kind == "endpoint" ? var.pod_defaults.endpoint : null
    offer_url = var.pod_defaults.kind == "offer" ? var.pod_defaults.url : null
  }
}

# Feast UI dashboard-links integration (kubeflow-dashboard:links -> feast-ui)
resource "juju_integration" "feast_ui_dashboard_links" {
  count      = var.dashboard_links != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_ui.name
    endpoint = "dashboard-links"
  }

  application {
    name      = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.name : null
    endpoint  = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.endpoint : null
    offer_url = var.dashboard_links.kind == "offer" ? var.dashboard_links.url : null
  }
}

# Feast UI ingress integration - sidecar (istio-pilot:ingress -> feast-ui)
resource "juju_integration" "feast_ui_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_ui.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# Feast UI istio-ingress-route integration - ambient (istio-ingress-k8s:istio-ingress-route -> feast-ui)
resource "juju_integration" "feast_ui_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_ui.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}

# Feast Integrator service-mesh integration - ambient (istio-beacon-k8s:service-mesh -> feast-integrator)
resource "juju_integration" "feast_integrator_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_integrator.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

# Feast UI service-mesh integration - ambient (istio-beacon-k8s:service-mesh -> feast-ui)
resource "juju_integration" "feast_ui_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.feast_ui.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

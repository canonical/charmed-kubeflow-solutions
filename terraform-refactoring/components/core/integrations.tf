# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Internal relations (within this component)

# Kubeflow Profiles to Kubeflow Dashboard
resource "juju_integration" "kubeflow_profiles_dashboard_kubeflow_profiles" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_profiles.name
    endpoint = "kubeflow-profiles"
  }

  application {
    name     = juju_application.kubeflow_dashboard.name
    endpoint = "kubeflow-profiles"
  }
}

# External ingress integrations (istio-pilot:ingress -> core apps)
# The same var.ingress is reused for all consumers, supporting both
# same-model (kind="endpoint") and cross-model (kind="offer") scenarios.

resource "juju_integration" "kubeflow_dashboard_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_dashboard.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

resource "juju_integration" "kubeflow_volumes_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_volumes.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# Ambient service-mesh integrations (istio-beacon-k8s:service-mesh -> core apps)

resource "juju_integration" "minio_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.minio.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "kubeflow_dashboard_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_dashboard.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "kubeflow_profiles_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_profiles.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "kubeflow_volumes_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_volumes.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

# Ambient istio-ingress-route integrations (istio-ingress-k8s:istio-ingress-route -> core apps)

resource "juju_integration" "kubeflow_dashboard_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_dashboard.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}

resource "juju_integration" "kubeflow_volumes_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_volumes.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}



# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# MLflow Server object-storage integration (minio:object-storage -> mlflow-server)
resource "juju_integration" "mlflow_server_object_storage" {
  count      = var.object_storage != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.mlflow_server.name
    endpoint = "object-storage"
  }

  application {
    name      = var.object_storage.kind == "endpoint" ? var.object_storage.name : null
    endpoint  = var.object_storage.kind == "endpoint" ? var.object_storage.endpoint : null
    offer_url = var.object_storage.kind == "offer" ? var.object_storage.url : null
  }
}

# MLflow Server ingress integration - sidecar (istio-pilot:ingress -> mlflow-server)
resource "juju_integration" "mlflow_server_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.mlflow_server.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# MLflow Server istio-ingress-route integration - ambient (istio-ingress-k8s:istio-ingress-route -> mlflow-server)
resource "juju_integration" "mlflow_server_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.mlflow_server.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}

# MLflow Server service-mesh integration - ambient (istio-beacon-k8s:service-mesh -> mlflow-server)
resource "juju_integration" "mlflow_server_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.mlflow_server.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

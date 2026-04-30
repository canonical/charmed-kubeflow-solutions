# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# MLflow Server dashboard-links integration (kubeflow-dashboard:links -> mlflow-server)
resource "juju_integration" "mlflow_server_dashboard_links" {
  count      = var.dashboard_links != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.mlflow_server.name
    endpoint = "dashboard-links"
  }

  application {
    name      = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.name : null
    endpoint  = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.endpoint : null
    offer_url = var.dashboard_links.kind == "offer" ? var.dashboard_links.url : null
  }
}

# MLflow Server relational-db integration (mysql-k8s:database -> mlflow-server)
resource "juju_integration" "mlflow_server_mysql_database" {
  count      = var.mysql_database != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.mlflow_server.name
    endpoint = "relational-db"
  }

  application {
    name      = var.mysql_database.kind == "endpoint" ? var.mysql_database.name : null
    endpoint  = var.mysql_database.kind == "endpoint" ? var.mysql_database.endpoint : null
    offer_url = var.mysql_database.kind == "offer" ? var.mysql_database.url : null
  }
}

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

# MLflow Server secrets integration (resource-dispatcher:secrets -> mlflow-server)
resource "juju_integration" "mlflow_server_secrets" {
  count      = var.secrets != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.mlflow_server.name
    endpoint = "secrets"
  }

  application {
    name      = var.secrets.kind == "endpoint" ? var.secrets.name : null
    endpoint  = var.secrets.kind == "endpoint" ? var.secrets.endpoint : null
    offer_url = var.secrets.kind == "offer" ? var.secrets.url : null
  }
}

# MLflow Server pod-defaults integration (resource-dispatcher:pod-defaults -> mlflow-server)
resource "juju_integration" "mlflow_server_pod_defaults" {
  count      = var.pod_defaults != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.mlflow_server.name
    endpoint = "pod-defaults"
  }

  application {
    name      = var.pod_defaults.kind == "endpoint" ? var.pod_defaults.name : null
    endpoint  = var.pod_defaults.kind == "endpoint" ? var.pod_defaults.endpoint : null
    offer_url = var.pod_defaults.kind == "offer" ? var.pod_defaults.url : null
  }
}

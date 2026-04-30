# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Training Operator dashboard-links integration (kubeflow-dashboard:links -> training-operator)
resource "juju_integration" "training_operator_dashboard_links" {
  count      = var.enable_v1 && var.dashboard_links != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.training_operator[0].name
    endpoint = "dashboard-links"
  }

  application {
    name      = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.name : null
    endpoint  = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.endpoint : null
    offer_url = var.dashboard_links.kind == "offer" ? var.dashboard_links.url : null
  }
}

# Kubeflow Trainer dashboard-links integration (kubeflow-dashboard:links -> kubeflow-trainer)
resource "juju_integration" "kubeflow_trainer_dashboard_links" {
  count      = var.enable_v2 && var.dashboard_links != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_trainer[0].name
    endpoint = "dashboard-links"
  }

  application {
    name      = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.name : null
    endpoint  = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.endpoint : null
    offer_url = var.dashboard_links.kind == "offer" ? var.dashboard_links.url : null
  }
}

# Ambient service-mesh integration (istio-beacon-k8s:service-mesh -> training-operator)
resource "juju_integration" "training_operator_service_mesh" {
  count      = var.enable_v1 && var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.training_operator[0].name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

# Ambient service-mesh integration (istio-beacon-k8s:service-mesh -> kubeflow-trainer)
resource "juju_integration" "kubeflow_trainer_service_mesh" {
  count      = var.enable_v2 && var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kubeflow_trainer[0].name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

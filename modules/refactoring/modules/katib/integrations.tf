resource "juju_integration" "istio_pilot_uiingress" {
  count = var.ingress.kind == "endpoint" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = var.ingress.name
    endpoint = var.ingress.endpoint
  }

  application {
    name     = juju_application.ui.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "istio_pilot_uiingress_offer" {
  count = var.ingress.kind == "offer" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    offer_url = var.ingress.url
  }

  application {
    name     = juju_application.ui.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "katib_db_manager_controller_k8s_service_info" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.db_manager.name
    endpoint = "k8s-service-info"
  }

  application {
    name     = juju_application.controller.name
    endpoint = "k8s-service-info"
  }
}

resource "juju_integration" "db_manager_db_relational_db" {
  count = var.db.kind == "endpoint" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.db_manager.name
    endpoint = "relational-db"
  }

  application {
    name     = var.db.name
    endpoint = var.db.endpoint
  }
}

resource "juju_integration" "db_manager_db_relational_db_offer" {
  count = var.db.kind == "offer" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.db_manager.name
    endpoint = "relational-db"
  }

  application {
    offer_url = var.db.url
  }
}

resource "juju_integration" "kubeflow_dashboard_ui_links" {
  count = var.dashboard_links.kind == "endpoint" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = var.dashboard_links.name
    endpoint = var.dashboard_links.endpoint
  }

  application {
    name     = juju_application.ui.name
    endpoint = "dashboard-links"
  }
}

resource "juju_integration" "kubeflow_dashboard_ui_links_offer" {
  count = var.dashboard_links.kind == "offer" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    offer_url = var.dashboard_links.url
  }

  application {
    name     = juju_application.ui.name
    endpoint = "dashboard-links"
  }
}

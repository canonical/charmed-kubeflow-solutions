resource "juju_integration" "istio_pilot_katib_uiingress" {
  count = var.ingress.kind == "endpoint" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = var.ingress.name
    endpoint = var.ingress.endpoint
  }

  application {
    name     = juju_application.katib_ui.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "istio_pilot_katib_uiingress_offer" {
  count = var.ingress.kind == "offer" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    offer_url = var.ingress.url
  }

  application {
    name     = juju_application.katib_ui.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "katib_db_manager_katib_controller_k8s_service_info" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.katib_db_manager.name
    endpoint = "k8s-service-info"
  }

  application {
    name     = juju_application.katib_controller.name
    endpoint = "k8s-service-info"
  }
}

resource "juju_integration" "katib_db_manager_katib_db_relational_db" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.katib_db_manager.name
    endpoint = "relational-db"
  }

  application {
    name     = var.db.deployed == "bundled"? module.db[0].app_name : var.db.info.name
    endpoint = var.db.deployed == "bundled"? module.db[0].provides.database : var.db.info.endpoint
  }
}

resource "juju_integration" "kubeflow_dashboard_katib_ui_links" {
  count = var.dashboard_links.kind == "endpoint" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = var.dashboard_links.name
    endpoint = var.dashboard_links.endpoint
  }

  application {
    name     = juju_application.katib_ui.name
    endpoint = "dashboard-links"
  }
}

resource "juju_integration" "kubeflow_dashboard_katib_ui_links_offer" {
  count = var.dashboard_links.kind == "offer" ? 1 : 0
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    offer_url = var.dashboard_links.url
  }

  application {
    name     = juju_application.katib_ui.name
    endpoint = "dashboard-links"
  }
}

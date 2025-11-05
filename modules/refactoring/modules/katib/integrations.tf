resource "juju_integration" "istio_pilot_katib_uiingress" {
  model_uuid = var.model # data.juju_model.kubeflow.uuid

  application {
    name     = var.ingress.name
    endpoint = var.ingress.endpoint
  }

  application {
    name     = juju_application.katib_ui.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "katib_db_manager_katib_controller_k8s_service_info" {
  model_uuid = var.model #data.juju_model.kubeflow.uuid

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
  model_uuid = var.model # data.juju_model.kubeflow.uuid

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
  model_uuid = var.model # data.juju_model.kubeflow.uuid

  application {
    name     = var.dashboard_links.name
    endpoint = var.dashboard_links.endpoint
  }

  application {
    name     = juju_application.katib_ui.name
    endpoint = "dashboard-links"
  }
}

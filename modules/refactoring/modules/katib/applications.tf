data "juju_model" "kubeflow" {
  uuid = var.model
  # owner = "admin"
}

resource "juju_application" "katib_controller" {
  charm {
    name     = "katib-controller"
    channel  = var.katib_controller.channel != null ? var.katib_controller.channel : "0.18/${var.risk}"
    revision = var.katib_controller.revision
  }
  config             = var.katib_controller.config
  constraints        = var.katib_controller.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.katib_controller.name
}


resource "juju_application" "katib_db_manager" {
  charm {
    name     = "katib-db-manager"
    channel  = var.katib_db_manager.channel != null ? var.katib_db_manager.channel : "0.18/${var.risk}"
    revision = var.katib_db_manager.revision
  }
  config             = var.katib_db_manager.config
  constraints        = var.katib_db_manager.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.katib_db_manager.name
}

resource "juju_application" "katib_ui" {
  charm {
    name     = "katib-ui"
    channel  = var.katib_ui.channel != null ? var.katib_ui.channel : "0.18/${var.risk}"
    revision = var.katib_ui.revision
  }
  config             = var.katib_ui.config
  constraints        = var.katib_ui.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.katib_ui.name
}




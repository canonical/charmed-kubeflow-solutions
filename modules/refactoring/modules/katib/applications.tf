data "juju_model" "kubeflow" {
  uuid = var.model_uuid
  # owner = "admin"
}

resource "juju_application" "controller" {
  charm {
    name     = "katib-controller"
    channel  = var.risk == null ? var.controller.channel : "0.18/${var.risk}"
    revision = var.controller.revision
  }
  config             = var.controller.config
  constraints        = var.controller.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.controller.name
}


resource "juju_application" "db_manager" {
  charm {
    name     = "katib-db-manager"
    channel  = var.risk == null ? var.db_manager.channel : "0.18/${var.risk}"
    revision = var.db_manager.revision
  }
  config             = var.db_manager.config
  constraints        = var.db_manager.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.db_manager.name
}

resource "juju_application" "ui" {
  charm {
    name     = "katib-ui"
    channel  = var.risk == null ? var.ui.channel : "0.18/${var.risk}"
    revision = var.ui.revision
  }
  config             = var.ui.config
  constraints        = var.ui.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.ui.name
}




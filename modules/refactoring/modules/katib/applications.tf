# data "juju_model" "kubeflow2" {
#   name = var.model
#   owner = "admin"
# }

resource "juju_application" "katib_controller" {
  charm {
    name     = "katib-controller"
    channel  = var.katib_controller.channel != null ? var.katib_controller.channel : "0.18/${var.risk}"
    revision = var.katib_controller.revision
  }
  config             = var.katib_controller.config
  constraints        = var.katib_controller.constraints
  model_uuid         = var.model # data.juju_model.kubeflow2.uuid
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
  model_uuid         = var.model # data.juju_model.kubeflow.uuid
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
  model_uuid         = var.model # data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.katib_ui.name
}

module "db" {
  count        = var.db.deployed == "bundled" ? 1 : 0
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=58072079edc97bace08b6ff9c8f380b94867ebd4"
  model = var.model # data.juju_model.kubeflow.uuid
  app_name   = "katib-db"
  channel    = "8.0/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.db.info.storage_size
  revision     = var.db.info.revision
}



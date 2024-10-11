resource "juju_integration" "mlflow_server_resource_dispatcher_secrets" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model_name

  application {
    name     = module.mlflow.mlflow_server.app_name
    endpoint = module.mlflow.mlflow_server.requires.secrets
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.secrets
  }
}

resource "juju_integration" "mlflow_server_resource_dispatcher_pod_defaults" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model_name

  application {
    name     = module.mlflow.mlflow_server.app_name
    endpoint = module.mlflow.mlflow_server.requires.pod_defaults
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.pod_defaults
  }
}

resource "juju_integration" "mlflow_minio_kserve_controller_object_storage" {
  count = var.mlflow_kserve_integration ?  1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model_name

  application {
    name     = module.mlflow.mlflow_minio.app_name
    endpoint = module.mlflow.mlflow_minio.provides.object_storage
  }

  application {
    name     = module.kubeflow.kserve_controller.app_name
    endpoint = module.kubeflow.kserve_controller.requires.object_storage
  }
}

resource "juju_integration" "kserve_controller_resource_dispatcher_service_accounts" {
  count = var.mlflow_kserve_integration ?  1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model_name

  application {
    name     = module.kubeflow.kserve_controller.app_name
    endpoint = module.kubeflow.kserve_controller.requires.service_accounts
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.service_accounts
  }
}

resource "juju_integration" "kserve_controller_resource_dispatcher_secrets" {
  count = var.mlflow_kserve_integration ?  1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model_name

  application {
    name     = module.kubeflow.kserve_controller.app_name
    endpoint = module.kubeflow.kserve_controller.requires.secrets
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.secrets
  }
}

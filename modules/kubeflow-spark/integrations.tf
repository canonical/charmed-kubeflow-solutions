
resource "juju_integration" "kubeflow_integrator_integration_hub" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "spark"
  }

  application {
    name     = juju_application.integration_hub.name
    endpoint = "spark-service-account"
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_secrets" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "secrets"
  }

  application {
    name     = juju_application.resource_dispatcher.name
    endpoint = "secrets"
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_service_accounts" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "service-accounts"
  }

  application {
    name     = juju_application.resource_dispatcher.name
    endpoint = "service-accounts"
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_poddefaults" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "pod-defaults"
  }

  application {
    name     = juju_application.resource_dispatcher.name
    endpoint = "pod-defaults"
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_roles" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "roles"
  }

  application {
    name     = juju_application.resource_dispatcher.name
    endpoint = "roles"
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_rolebindings" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "role-bindings"
  }

  application {
    name     = juju_application.resource_dispatcher.name
    endpoint = "role-bindings"
  }
}


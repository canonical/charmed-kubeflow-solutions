
resource "juju_integration" "kubeflow_integrator_integration_hub" {
  model = module.kubeflow.model

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
  model = module.kubeflow.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "secrets"
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.secrets
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_service_accounts" {
  model = module.kubeflow.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "service-accounts"
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.service_accounts
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_poddefaults" {
  model = module.kubeflow.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "pod-defaults"
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.pod_defaults
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_roles" {
  model = module.kubeflow.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "roles"
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.roles
  }
}

resource "juju_integration" "kubeflow_integrator_resource_dispatcher_rolebindings" {
  model = module.kubeflow.model

  application {
    name     = juju_application.kubeflow_integrator.name
    endpoint = "role-bindings"
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.role_bindings
  }
}


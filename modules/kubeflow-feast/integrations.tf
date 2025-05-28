resource "juju_integration" "feast_integrator_offline_store" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.offline_store
  }

  application {
    name     = module.offline_store.app_name
    endpoint = module.offline_store.provides.database
  }
}

resource "juju_integration" "feast_integrator_online_store" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.online_store
  }

  application {
    name     = module.online_store.app_name
    endpoint = module.online_store.provides.database
  }
}

resource "juju_integration" "feast_integrator_registry" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.registry
  }

  application {
    name     = module.registry.app_name
    endpoint = module.registry.provides.database
  }
}

resource "juju_integration" "feast_integrator_resource_dispatcher_secrets" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.secrets
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.secrets
  }
}

resource "juju_integration" "feast_integrator_resource_dispatcher_secrets" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.secrets
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.secrets
  }
}
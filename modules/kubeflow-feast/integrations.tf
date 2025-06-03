resource "juju_integration" "feast_integrator_feast_offline_store" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.feast_offline_store
  }

  application {
    name     = module.feast_offline_store.application_name
    endpoint = module.feast_offline_store.provides.database
  }
}

resource "juju_integration" "feast_integrator_feast_online_store" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.feast_online_store
  }

  application {
    name     = module.feast_online_store.application_name
    endpoint = module.feast_online_store.provides.database
  }
}

resource "juju_integration" "feast_integrator_feast_registry" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.feast_registry
  }

  application {
    name     = module.feast_registry.application_name
    endpoint = module.feast_registry.provides.database
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

resource "juju_integration" "feast_integrator_resource_dispatcher_pod_defaults" {
  model = module.kubeflow.model

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.requires.pod_defaults
  }

  application {
    name     = module.resource_dispatcher.app_name
    endpoint = module.resource_dispatcher.provides.pod_defaults
  }
}

resource "juju_integration" "feast_ui_feast_integrator" {
  model = module.kubeflow.model

  application {
    name     = module.feast_ui.app_name
    endpoint = module.feast_ui.requires.feast_configuration
  }

  application {
    name     = module.feast_integrator.app_name
    endpoint = module.feast_integrator.provides.feast_configuration
  }
}

resource "juju_integration" "feast_ui_ingress_provider_ingress" {
  model = module.kubeflow.model

  application {
    name     = module.feast_ui.app_name
    endpoint = module.feast_ui.requires.ingress
  }

  application {
    name     = module.kubeflow.ingress_provider.app_name
    endpoint = module.kubeflow.ingress_provider.provides.ingress
  }
}

resource "juju_integration" "feast_ui_dashboard_links_provider_links" {
  model = module.kubeflow.model

  application {
    name     = module.feast_ui.app_name
    endpoint = module.feast_ui.requires.dashboard_links
  }

  application {
    name     = module.kubeflow.dashboard_links_provider.app_name
    endpoint = module.kubeflow.dashboard_links_provider.provides.links
  }
}

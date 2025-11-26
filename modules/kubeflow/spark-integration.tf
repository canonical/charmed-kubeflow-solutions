# APPLICATIONS

resource "juju_application" "resource_dispatcher" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model
  name  = "resource-dispatcher"
  charm {
    name     = "resource-dispatcher"
    channel  = "latest/edge"
  }
  units       = 1
  trust       = true
  constraints = "arch=amd64"
}

resource "juju_application" "integration_hub" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model
  name  = "integration-hub"
  charm {
    name     = "spark-integration-hub-k8s"
    channel  = "3/edge"
  }
  units       = 1
  trust       = true
  constraints = "arch=amd64"
}


resource "juju_application" "kubeflow_integrator" {
 model = var.create_model ? juju_model.kubeflow[0].name : local.model
  name  = "kubeflow-integrator"
  charm {
    name     = "data-kubeflow-integrator"
    channel  = "1/edge/pr-8"
    revision = 12
  }
  units       = 1
  constraints = "arch=amd64"
  trust       = true
  config = {
    spark-service-account = format("%s:%s", var.create_model ? juju_model.kubeflow[0].name : local.model, "spark")
    profile = "*"
  }
}







# INTEGRATIONS

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


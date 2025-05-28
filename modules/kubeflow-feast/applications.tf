module "feast_integrator" {
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/feast-operators//charms/feast-integrator/terraform?ref=main"
  model_name = module.kubeflow.model
  revision   = var.feast_integrator_revision
}

module "feast_ui" {
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/feast-operators//charms/feast-ui/terraform?ref=main"
  model_name = module.kubeflow.model
  revision   = var.feast_ui_revision
}

module "offline_store" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=main"
  juju_model_name = module.kubeflow.model
  app_name        = "offline-store"
  channel         = "14/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.offline_store_size
  revision     = var.offline_store_revision
}

module "online_store" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=main"
  juju_model_name = module.kubeflow.model
  app_name        = "online-store"
  channel         = "14/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.online_store_size
  revision     = var.online_store_revision
}

module "registry" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=main"
  juju_model_name = module.kubeflow.model
  app_name        = "registry"
  channel         = "14/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.registry_size
  revision     = var.registry_revision
}

module "resource_dispatcher" {
  source     = "git::https://github.com/canonical/resource-dispatcher//terraform?ref=track/2.0"
  model_name = module.kubeflow.model
  revision   = var.resource_dispatcher_revision
}

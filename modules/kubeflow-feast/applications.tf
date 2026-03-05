module "feast_integrator" {
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/feast-operators//charms/feast-integrator/terraform?ref=track/0.49"
  model_name = module.kubeflow.model
  revision   = var.feast_integrator_revision
  channel    = "0.49/${var.risk}"
}

module "feast_ui" {
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/feast-operators//charms/feast-ui/terraform?ref=track/0.49"
  model_name = module.kubeflow.model
  revision   = var.feast_ui_revision
  channel    = "0.49/${var.risk}"
}

module "feast_offline_store" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=ac1f27eae4d9ccee2557ec84a175fbb5722e45be"
  juju_model_name = module.kubeflow.model
  app_name        = "feast-offline-store"
  channel         = "14/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile_limit_memory = "2048"
  }
  storage_size = var.feast_offline_store_size
  revision     = var.feast_offline_store_revision
}

module "feast_online_store" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=ac1f27eae4d9ccee2557ec84a175fbb5722e45be"
  juju_model_name = module.kubeflow.model
  app_name        = "feast-online-store"
  channel         = "14/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile_limit_memory = "2048"
  }
  storage_size = var.feast_online_store_size
  revision     = var.feast_online_store_revision
}

module "feast_registry" {
  # tflint-ignore: terraform_module_pinned_source
  source          = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=ac1f27eae4d9ccee2557ec84a175fbb5722e45be"
  juju_model_name = module.kubeflow.model
  app_name        = "feast-registry"
  channel         = "14/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile_limit_memory = "2048"
  }
  storage_size = var.feast_registry_size
  revision     = var.feast_registry_revision
}

module "resource_dispatcher" {
  source     = "git::https://github.com/canonical/resource-dispatcher//terraform?ref=track/2.0"
  model_name = module.kubeflow.model
  revision   = var.resource_dispatcher_revision
  channel    = "2.0/${var.risk}"
}

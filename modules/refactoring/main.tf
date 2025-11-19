resource "juju_model" "kubeflow" {
  name  = "kubeflow"
  # owner = "admin"
  config = {
    juju-http-proxy = var.http_proxy
    juju-https-proxy = var.https_proxy
    no-proxy = var.no_proxy
  }
}

# Single MySQL database
module "db" {
  depends_on = [juju_model.kubeflow]
  count        = var.db.deployed == "shared" ? 1 : 0
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=58072079edc97bace08b6ff9c8f380b94867ebd4"
  model = juju_model.kubeflow.uuid
  app_name   = "mysql"
  channel    = "8.0/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.db.info.storage_size
  revision     = var.db.info.revision
}

module "core" {
  depends_on = [juju_model.kubeflow, module.db]
  source = "./modules/core"
  model = juju_model.kubeflow.uuid
}

module "katib" {
  depends_on = [module.core, module.db, juju_model.kubeflow]
  count = contains(var.components, "katib") ? 1 : 0
  source = "./modules/katib"
  model = juju_model.kubeflow.uuid
  ingress = module.core.offers.ingress
  dashboard_links = module.core.offers.dashboard_links

  # Dedicated DB
  db = var.db.deployed == "private" ? {
    deployed = "bundled",
    info = {
      name = null
      endpoint = null
      revision = null
    }
  } : ( var.db.deployed == "shared" ? {
    deployed = "external",
    info = {
      name     = module.db[0].app_name,
      endpoint = "database" # module.db[0].provides.database
      revision = null
    }
  } : {
    deployed = "external",
    info = {
      name = null,
      endpoint = null,
      revision = var.db.info.revision
    }
  } )
}
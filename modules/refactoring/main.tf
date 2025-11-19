resource "juju_model" "kubeflow" {
  name  = "kubeflow"
  # owner = "admin"
  config = {
    juju-http-proxy = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy = var.no_proxy
  }
}

module "core" {
  depends_on = [juju_model.kubeflow]
  source = "./modules/core"
  model = juju_model.kubeflow.uuid
}

resource "juju_offer" "ingress" {
  application_name = module.core.offers.ingress.name
  endpoints = [module.core.offers.ingress.endpoint]
  model_uuid       = juju_model.kubeflow.uuid
}

resource "juju_offer" "dashboard_links" {
  application_name = module.core.offers.dashboard_links.name
  endpoints = [module.core.offers.dashboard_links.endpoint]
  model_uuid       = juju_model.kubeflow.uuid
}


resource "juju_model" "katib" {
  name  = "katib"
  # owner = "admin"
  config = {
    juju-http-proxy = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy = var.no_proxy
  }
}


# Single MySQL database
module "central_db" {
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

resource "juju_offer" "central_db" {
  count        = var.db.deployed == "shared" ? 1 : 0
  application_name = module.central_db[0].app_name
  endpoints = ["database"]
  model_uuid       = juju_model.kubeflow.uuid
}


# Private Database
module "katib_db" {
  depends_on = [juju_model.katib]
  count        = var.db.deployed == "private" ? 1 : 0
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=58072079edc97bace08b6ff9c8f380b94867ebd4"
  model = juju_model.katib.uuid
  app_name   = "katib-db"
  channel    = "8.0/stable"
  # The following config is equivalent to "constraints: mem=2G"
  config = {
    profile-limit-memory = "2048"
  }
  storage_size = var.db.info.storage_size
  revision     = var.db.info.revision
}

module "katib" {
  # depends_on = [module.core, module.central_db, , juju_model.katib]
  count = contains(var.components, "katib") ? 1 : 0
  source = "./modules/katib"
  model = juju_model.katib.uuid
  ingress = {
    kind = "offer",
    url = juju_offer.ingress.url
  }
  dashboard_links = {
    kind = "offer"
    url = juju_offer.dashboard_links.url
  }

  # Dedicated DB
  db = var.db.deployed == "private" ? {
    kind     = "endpoint"
    name     = module.katib_db[0].app_name,
    endpoint = "database"
  } : ( var.db.deployed == "shared" ? {
    kind = "offer"
    url = juju_offer.central_db[0].url
  } : {
    kind = "offer"
    url = var.db.info.offer
  } )
}
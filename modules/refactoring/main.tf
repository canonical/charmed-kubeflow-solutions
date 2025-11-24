resource "juju_model" "kubeflow" {
  name  = "kubeflow"
  # owner = "admin"
  config = {
    juju-http-proxy = var.proxy.http
    juju-https-proxy = var.proxy.https
    juju-no-proxy = var.proxy.no-proxy
  }
}

module "core" {
  depends_on = [juju_model.kubeflow]
  source = "./modules/core"
  model = juju_model.kubeflow.uuid
  expose_endpoints = ["envoy_metrics", "ingress"]
}

# resource "juju_offer" "ingress" {
#   application_name = module.core.provides.ingress.name
#   endpoints = [module.core.provides.ingress.endpoint]
#   model_uuid       = juju_model.kubeflow.uuid
# }

resource "juju_offer" "dashboard_links" {
  application_name = module.core.provides.dashboard_links.name
  endpoints = [module.core.provides.dashboard_links.endpoint]
  model_uuid       = juju_model.kubeflow.uuid
}


resource "juju_model" "katib" {
  name  = "katib"
  # owner = "admin"
  config = {
    juju-http-proxy = var.proxy.http
    juju-https-proxy = var.proxy.https
    juju-no-proxy = var.proxy.no-proxy
  }
}


# Central MySQL database
module "central_db" {
  depends_on = [juju_model.kubeflow]
  count        = local.is_central_db_deployed ? 1 : 0
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=58072079edc97bace08b6ff9c8f380b94867ebd4"
  model = juju_model.kubeflow.uuid # non-compliant
  app_name   = var.central_db.name
  channel    = var.central_db.channel
  config = var.central_db.config
  storage_size = var.central_db.storage_size
  revision     = var.central_db.revision
}

resource "juju_offer" "central_db" {
  count        = local.is_central_db_deployed ? 1 : 0
  application_name = module.central_db[0].app_name
  endpoints = ["database"]
  model_uuid       = juju_model.kubeflow.uuid
}


# Private Database
module "katib_db" {
  depends_on = [juju_model.katib]
  count        = var.katib.db == "private" ? 1 : 0
  # tflint-ignore: terraform_module_pinned_source
  source     = "git::https://github.com/canonical/mysql-k8s-operator//terraform?ref=58072079edc97bace08b6ff9c8f380b94867ebd4"
  model = juju_model.katib.uuid # non-compliant
  app_name   = var.katib_db.name
  channel    = var.katib_db.channel
  config = var.katib_db.config
  storage_size = var.katib_db.storage_size
  revision     = var.katib_db.revision
}

module "katib" {
  # depends_on = [module.core, module.central_db, , juju_model.katib]
  count = local.is_katib_deployed ? 1 : 0
  source = "./modules/katib"
  model_uuid = juju_model.katib.uuid
  ingress = {
    kind = "offer",
    url = module.core.offers["ingress"] # juju_offer.ingress.url
  }
  dashboard_links = {
    kind = "offer"
    url = juju_offer.dashboard_links.url
  }

  # Dedicated DB
  db = var.katib.db == "private" ? {
    kind     = "endpoint"
    name     = module.katib_db[0].app_name,
    endpoint = "database"
  } : ( var.katib.db == "shared" ? {
    kind = "offer"
    url = juju_offer.central_db[0].url
  } : {
    kind = "offer"
    url = var.katib.db_offer
  } )
}
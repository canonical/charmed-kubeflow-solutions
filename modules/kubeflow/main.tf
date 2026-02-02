resource "juju_model" "kubeflow" {
  count = var.create_model ? 1 : 0
  name  = local.model

  config = {
    juju-http-proxy  = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy    = var.no_proxy
  }
}

locals {
  model = "kubeflow"
}

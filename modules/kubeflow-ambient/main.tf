resource "juju_model" "istio" {
  count = var.create_model ? 1 : 0
  name  = local.kubeflow_platform_model

  config = {
    juju-http-proxy  = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy    = var.no_proxy
  }
}

resource "juju_model" "kubeflow" {
  count = var.create_model ? 1 : 0
  name  = local.istio_system_model

  config = {
    juju-http-proxy  = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy    = var.no_proxy
  }
}

locals {
  istio_system_model = "istio-system"
  kubeflow_platform_model = "kubeflow"
}

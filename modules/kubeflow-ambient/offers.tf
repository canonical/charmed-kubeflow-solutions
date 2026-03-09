resource "juju_offer" "istio_ingress_k8s_ingress_config" {
  model            = var.create_model ? juju_model.kubeflow[0].name : local.kubeflow_platform_model
  application_name = juju_application.istio_ingress_k8s.name
  endpoints        = ["istio-ingress-config"]
}

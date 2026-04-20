output "components" {
  description = "Map of the deployed Istio applications"
  value = {
    istio_pilot          = juju_application.istio_pilot
    istio_ingressgateway = juju_application.istio_ingressgateway
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    istio_ingressgateway_gateway = {
      name     = juju_application.istio_ingressgateway.name
      endpoint = "gateway"
    }
    istio_pilot_ingress = {
      name     = juju_application.istio_pilot.name
      endpoint = "ingress"
    }
    istio_pilot_ingress_auth = {
      name     = juju_application.istio_pilot.name
      endpoint = "ingress-auth"
    }
  }
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed KServe applications"
  value = merge(
    {
      kserve_controller = juju_application.kserve_controller
    },
    length(juju_application.knative_operator) > 0 ? { knative_operator = juju_application.knative_operator[0] } : {},
    length(juju_application.knative_serving) > 0 ? { knative_serving = juju_application.knative_serving[0] } : {},
    length(juju_application.knative_eventing) > 0 ? { knative_eventing = juju_application.knative_eventing[0] } : {},
  )
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    kserve_controller_ingress_gateway = {
      name     = juju_application.kserve_controller.name
      endpoint = "ingress-gateway"
    }
    kserve_controller_object_storage = {
      name     = juju_application.kserve_controller.name
      endpoint = "object-storage"
    }
  }
}

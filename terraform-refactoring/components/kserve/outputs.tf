# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed KServe applications"
  value = {
    kserve_controller = juju_application.kserve_controller
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    kserve_controller_ingress_gateway = {
      name     = juju_application.kserve_controller.name
      endpoint = "ingress-gateway"
    }
  }
}

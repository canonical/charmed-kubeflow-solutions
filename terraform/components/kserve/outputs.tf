# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed KServe applications"
  value = {
    kserve_controller = juju_application.kserve_controller
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    kserve_controller_metrics_endpoint = {
      name     = juju_application.kserve_controller.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    kserve_controller_s3_credentials = {
      name     = juju_application.kserve_controller.name
      endpoint = "s3-credentials"
    }
    kserve_controller_object_storage = {
      name     = juju_application.kserve_controller.name
      endpoint = "object-storage"
    }
    kserve_controller_secrets = {
      name     = juju_application.kserve_controller.name
      endpoint = "secrets"
    }
    kserve_controller_service_accounts = {
      name     = juju_application.kserve_controller.name
      endpoint = "service-accounts"
    }
    kserve_controller_logging = {
      name     = juju_application.kserve_controller.name
      endpoint = "logging"
    }
  }
}

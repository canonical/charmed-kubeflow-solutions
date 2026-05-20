# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  knative_deployed = var.gateway_info != null

  knative_operator = local.knative_deployed ? juju_application.knative_operator[0] : null
  knative_serving  = local.knative_deployed ? juju_application.knative_serving[0] : null
  knative_eventing = local.knative_deployed ? juju_application.knative_eventing[0] : null
}

output "components" {
  description = "Map of the deployed KServe applications"
  value = merge(
    {
      kserve_controller = juju_application.kserve_controller
    },
    local.knative_deployed ? {
      knative_operator = local.knative_operator
      knative_serving  = local.knative_serving
      knative_eventing = local.knative_eventing
    } : {},
  )
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = merge(
    {
      kserve_controller_metrics_endpoint = {
        name     = juju_application.kserve_controller.name
        endpoint = "metrics-endpoint"
      }
    },
    local.knative_deployed ? {
      knative_operator_metrics_endpoint = {
        name     = local.knative_operator.name
        endpoint = "metrics-endpoint"
      }
      knative_operator_otel_collector = {
        name     = local.knative_operator.name
        endpoint = "otel-collector"
      }
    } : {}
  )
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = merge(
    {
      kserve_controller_ingress_gateway = {
        name     = juju_application.kserve_controller.name
        endpoint = "ingress-gateway"
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
    },
    local.knative_deployed ? {
      knative_operator_logging = {
        name     = local.knative_operator.name
        endpoint = "logging"
      }
      knative_serving_otel_collector = {
        name     = local.knative_serving.name
        endpoint = "otel-collector"
      }
      knative_eventing_otel_collector = {
        name     = local.knative_eventing.name
        endpoint = "otel-collector"
      }
    } : {}
  )
}

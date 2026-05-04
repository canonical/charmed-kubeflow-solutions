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

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = merge(
    {
      kserve_controller_metrics_endpoint = {
        name     = juju_application.kserve_controller.name
        endpoint = "metrics-endpoint"
      }
    },
    length(juju_application.knative_operator) > 0 ? {
      knative_operator_metrics_endpoint = {
        name     = juju_application.knative_operator[0].name
        endpoint = "metrics-endpoint"
      }
      knative_operator_otel_collector = {
        name     = juju_application.knative_operator[0].name
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
    length(juju_application.knative_operator) > 0 ? {
      knative_operator_logging = {
        name     = juju_application.knative_operator[0].name
        endpoint = "logging"
      }
    } : {},
    length(juju_application.knative_serving) > 0 ? {
      knative_serving_otel_collector = {
        name     = juju_application.knative_serving[0].name
        endpoint = "otel-collector"
      }
    } : {},
    length(juju_application.knative_eventing) > 0 ? {
      knative_eventing_otel_collector = {
        name     = juju_application.knative_eventing[0].name
        endpoint = "otel-collector"
      }
    } : {}
  )
}

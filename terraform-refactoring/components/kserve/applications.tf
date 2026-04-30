# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Knative Operator application (deployed only in sidecar/serverless mode)
resource "juju_application" "knative_operator" {
  count = var.gateway_info != null ? 1 : 0

  charm {
    name     = "knative-operator"
    channel  = var.knative_operator.channel
    revision = var.knative_operator.revision
  }

  model_uuid  = var.model_uuid
  name        = var.knative_operator.app_name
  units       = var.knative_operator.units
  trust       = var.knative_operator.trust
  constraints = var.knative_operator.constraints
  config      = var.knative_operator.config
  resources   = var.knative_operator.resources
}

# Knative Serving application (deployed only in sidecar/serverless mode)
resource "juju_application" "knative_serving" {
  count = var.gateway_info != null ? 1 : 0

  charm {
    name     = "knative-serving"
    channel  = var.knative_serving.channel
    revision = var.knative_serving.revision
  }

  model_uuid  = var.model_uuid
  name        = var.knative_serving.app_name
  units       = var.knative_serving.units
  trust       = var.knative_serving.trust
  constraints = var.knative_serving.constraints
  config      = var.knative_serving.config
  resources   = var.knative_serving.resources
}

# Knative Eventing application (deployed only in sidecar/serverless mode)
resource "juju_application" "knative_eventing" {
  count = var.gateway_info != null ? 1 : 0

  charm {
    name     = "knative-eventing"
    channel  = var.knative_eventing.channel
    revision = var.knative_eventing.revision
  }

  model_uuid  = var.model_uuid
  name        = var.knative_eventing.app_name
  units       = var.knative_eventing.units
  trust       = var.knative_eventing.trust
  constraints = var.knative_eventing.constraints
  config      = var.knative_eventing.config
  resources   = var.knative_eventing.resources
}

# KServe Controller application
resource "juju_application" "kserve_controller" {
  charm {
    name     = "kserve-controller"
    channel  = var.kserve_controller.channel
    revision = var.kserve_controller.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kserve_controller.app_name
  units       = var.kserve_controller.units
  trust       = var.kserve_controller.trust
  constraints = var.kserve_controller.constraints
  config      = var.kserve_controller.config
  resources   = var.kserve_controller.resources
}

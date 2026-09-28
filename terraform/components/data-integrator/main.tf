# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_application" "data_integrator" {
  charm {
    name     = "data-integrator"
    channel  = var.data_integrator.channel
    revision = var.data_integrator.revision
  }

  model_uuid  = var.model_uuid
  name        = var.data_integrator.app_name
  config      = var.data_integrator.config
  units       = var.data_integrator.units
  trust       = var.data_integrator.trust
  constraints = var.data_integrator.constraints
}

resource "juju_integration" "data_integrator_mlflow_server" {
  count      = var.mlflow_server_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.data_integrator.name
    endpoint = "mlflow"
  }

  application {
    name      = var.mlflow_server_endpoint.name
    endpoint  = "mlflow_server"
  }
}

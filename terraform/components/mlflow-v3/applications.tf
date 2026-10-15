# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# MLflow Server application
resource "juju_application" "mlflow_server" {
  charm {
    name     = "mlflow-server"
    channel  = var.mlflow_server.channel
    revision = var.mlflow_server.revision
  }

  model_uuid  = var.model_uuid
  name        = var.mlflow_server.app_name
  units       = var.mlflow_server.units
  trust       = var.mlflow_server.trust
  constraints = var.mlflow_server.constraints
  config      = var.mlflow_server.config
  resources   = var.mlflow_server.resources
}

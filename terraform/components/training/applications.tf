# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Training Operator application (optional, enabled with enable_v1)
resource "juju_application" "training_operator" {
  count = var.enable_v1 ? 1 : 0

  charm {
    name     = "training-operator"
    channel  = var.training_operator.channel
    revision = var.training_operator.revision
  }

  model_uuid  = var.model_uuid
  name        = var.training_operator.app_name
  units       = var.training_operator.units
  trust       = var.training_operator.trust
  constraints = var.training_operator.constraints
  config      = var.training_operator.config
  resources   = var.training_operator.resources
}

# Kubeflow Trainer application (optional, enabled with enable_v2)
resource "juju_application" "kubeflow_trainer" {
  count = var.enable_v2 ? 1 : 0

  charm {
    name     = "kubeflow-trainer"
    channel  = var.kubeflow_trainer.channel
    revision = var.kubeflow_trainer.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kubeflow_trainer.app_name
  units       = var.kubeflow_trainer.units
  trust       = var.kubeflow_trainer.trust
  constraints = var.kubeflow_trainer.constraints
  config      = var.kubeflow_trainer.config
  resources   = var.kubeflow_trainer.resources
}

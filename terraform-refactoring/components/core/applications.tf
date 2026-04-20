# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# MinIO object storage application
resource "juju_application" "minio" {
  charm {
    name     = "minio"
    channel  = var.minio.channel
    revision = var.minio.revision
  }

  model_uuid  = var.model_uuid
  name        = "minio"
  units       = var.minio.units
  trust       = var.minio.trust
  constraints = var.minio.constraints
  config      = var.minio.config
  resources   = var.minio.resources
}

# MLMD (ML Metadata) application
resource "juju_application" "mlmd" {
  charm {
    name     = "mlmd"
    channel  = var.mlmd.channel
    revision = var.mlmd.revision
  }

  model_uuid  = var.model_uuid
  name        = "mlmd"
  units       = var.mlmd.units
  trust       = var.mlmd.trust
  constraints = var.mlmd.constraints
  config      = var.mlmd.config
  resources   = var.mlmd.resources
}

# Envoy proxy application
resource "juju_application" "envoy" {
  charm {
    name     = "envoy"
    channel  = var.envoy.channel
    revision = var.envoy.revision
  }

  model_uuid  = var.model_uuid
  name        = "envoy"
  units       = var.envoy.units
  trust       = var.envoy.trust
  constraints = var.envoy.constraints
  config      = var.envoy.config
  resources   = var.envoy.resources
}

# Kubeflow Dashboard application
resource "juju_application" "kubeflow_dashboard" {
  charm {
    name     = "kubeflow-dashboard"
    channel  = var.kubeflow_dashboard.channel
    revision = var.kubeflow_dashboard.revision
  }

  model_uuid  = var.model_uuid
  name        = "kubeflow-dashboard"
  units       = var.kubeflow_dashboard.units
  trust       = var.kubeflow_dashboard.trust
  constraints = var.kubeflow_dashboard.constraints
  config      = var.kubeflow_dashboard.config
  resources   = var.kubeflow_dashboard.resources
}

# Kubeflow Profiles application
resource "juju_application" "kubeflow_profiles" {
  charm {
    name     = "kubeflow-profiles"
    channel  = var.kubeflow_profiles.channel
    revision = var.kubeflow_profiles.revision
  }

  model_uuid  = var.model_uuid
  name        = "kubeflow-profiles"
  units       = var.kubeflow_profiles.units
  trust       = var.kubeflow_profiles.trust
  constraints = var.kubeflow_profiles.constraints
  config      = var.kubeflow_profiles.config
  resources   = var.kubeflow_profiles.resources
}

# Kubeflow Roles application
resource "juju_application" "kubeflow_roles" {
  charm {
    name     = "kubeflow-roles"
    channel  = var.kubeflow_roles.channel
    revision = var.kubeflow_roles.revision
  }

  model_uuid  = var.model_uuid
  name        = "kubeflow-roles"
  units       = var.kubeflow_roles.units
  trust       = var.kubeflow_roles.trust
  constraints = var.kubeflow_roles.constraints
  config      = var.kubeflow_roles.config
  resources   = var.kubeflow_roles.resources
}

# Kubeflow Volumes application
resource "juju_application" "kubeflow_volumes" {
  charm {
    name     = "kubeflow-volumes"
    channel  = var.kubeflow_volumes.channel
    revision = var.kubeflow_volumes.revision
  }

  model_uuid  = var.model_uuid
  name        = "kubeflow-volumes"
  units       = var.kubeflow_volumes.units
  trust       = var.kubeflow_volumes.trust
  constraints = var.kubeflow_volumes.constraints
  config      = var.kubeflow_volumes.config
  resources   = var.kubeflow_volumes.resources
}

# Metacontroller Operator application
resource "juju_application" "metacontroller_operator" {
  charm {
    name     = "metacontroller-operator"
    channel  = var.metacontroller_operator.channel
    revision = var.metacontroller_operator.revision
  }

  model_uuid  = var.model_uuid
  name        = "metacontroller-operator"
  units       = var.metacontroller_operator.units
  trust       = var.metacontroller_operator.trust
  constraints = var.metacontroller_operator.constraints
  config      = var.metacontroller_operator.config
  resources   = var.metacontroller_operator.resources
}

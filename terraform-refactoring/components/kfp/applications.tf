# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

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

# Argo Controller application
resource "juju_application" "argo_controller" {
  charm {
    name     = "argo-controller"
    channel  = var.argo_controller.channel
    revision = var.argo_controller.revision
  }

  model_uuid  = var.model_uuid
  name        = var.argo_controller.app_name
  units       = var.argo_controller.units
  trust       = var.argo_controller.trust
  constraints = var.argo_controller.constraints
  config      = var.argo_controller.config
  resources = var.argo_controller.resources
}

# KFP API application
resource "juju_application" "kfp_api" {
  charm {
    name     = "kfp-api"
    channel  = var.kfp_api.channel
    revision = var.kfp_api.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kfp_api.app_name
  units       = var.kfp_api.units
  trust       = var.kfp_api.trust
  constraints = var.kfp_api.constraints
  config      = var.kfp_api.config
  resources   = var.kfp_api.resources
}

# KFP Metadata Writer application
resource "juju_application" "kfp_metadata_writer" {
  charm {
    name     = "kfp-metadata-writer"
    channel  = var.kfp_metadata_writer.channel
    revision = var.kfp_metadata_writer.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kfp_metadata_writer.app_name
  units       = var.kfp_metadata_writer.units
  trust       = var.kfp_metadata_writer.trust
  constraints = var.kfp_metadata_writer.constraints
  config      = var.kfp_metadata_writer.config
  resources   = var.kfp_metadata_writer.resources
}

# KFP Persistence application
resource "juju_application" "kfp_persistence" {
  charm {
    name     = "kfp-persistence"
    channel  = var.kfp_persistence.channel
    revision = var.kfp_persistence.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kfp_persistence.app_name
  units       = var.kfp_persistence.units
  trust       = var.kfp_persistence.trust
  constraints = var.kfp_persistence.constraints
  config      = var.kfp_persistence.config
  resources   = var.kfp_persistence.resources
}

# KFP Profile Controller application
resource "juju_application" "kfp_profile_controller" {
  charm {
    name     = "kfp-profile-controller"
    channel  = var.kfp_profile_controller.channel
    revision = var.kfp_profile_controller.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kfp_profile_controller.app_name
  units       = var.kfp_profile_controller.units
  trust       = var.kfp_profile_controller.trust
  constraints = var.kfp_profile_controller.constraints
  config      = var.kfp_profile_controller.config
  resources   = var.kfp_profile_controller.resources
}

# KFP Scheduled Workflow application
resource "juju_application" "kfp_schedwf" {
  charm {
    name     = "kfp-schedwf"
    channel  = var.kfp_schedwf.channel
    revision = var.kfp_schedwf.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kfp_schedwf.app_name
  units       = var.kfp_schedwf.units
  trust       = var.kfp_schedwf.trust
  constraints = var.kfp_schedwf.constraints
  config      = var.kfp_schedwf.config
  resources   = var.kfp_schedwf.resources
}

# KFP UI application
resource "juju_application" "kfp_ui" {
  charm {
    name     = "kfp-ui"
    channel  = var.kfp_ui.channel
    revision = var.kfp_ui.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kfp_ui.app_name
  units       = var.kfp_ui.units
  trust       = var.kfp_ui.trust
  constraints = var.kfp_ui.constraints
  config      = var.kfp_ui.config
  resources   = var.kfp_ui.resources
}

# KFP Viewer application
resource "juju_application" "kfp_viewer" {
  charm {
    name     = "kfp-viewer"
    channel  = var.kfp_viewer.channel
    revision = var.kfp_viewer.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kfp_viewer.app_name
  units       = var.kfp_viewer.units
  trust       = var.kfp_viewer.trust
  constraints = var.kfp_viewer.constraints
  config      = var.kfp_viewer.config
  resources   = var.kfp_viewer.resources
}

# KFP Visualization application
resource "juju_application" "kfp_viz" {
  charm {
    name     = "kfp-viz"
    channel  = var.kfp_viz.channel
    revision = var.kfp_viz.revision
  }

  model_uuid  = var.model_uuid
  name        = var.kfp_viz.app_name
  units       = var.kfp_viz.units
  trust       = var.kfp_viz.trust
  constraints = var.kfp_viz.constraints
  config      = var.kfp_viz.config
  resources   = var.kfp_viz.resources
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed KFP applications"
  value = {
    argo_controller        = juju_application.argo_controller
    envoy                  = juju_application.envoy
    kfp_api                = juju_application.kfp_api
    mlmd                   = juju_application.mlmd
    kfp_metadata_writer    = juju_application.kfp_metadata_writer
    kfp_persistence        = juju_application.kfp_persistence
    kfp_profile_controller = juju_application.kfp_profile_controller
    kfp_schedwf            = juju_application.kfp_schedwf
    kfp_ui                 = juju_application.kfp_ui
    kfp_viewer             = juju_application.kfp_viewer
    kfp_viz                = juju_application.kfp_viz
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    mlmd_grpc = {
      name     = juju_application.mlmd.name
      endpoint = "grpc"
    }
    argo_controller_grafana_dashboard = {
      name     = juju_application.argo_controller.name
      endpoint = "grafana-dashboard"
    }
    argo_controller_metrics_endpoint = {
      name     = juju_application.argo_controller.name
      endpoint = "metrics-endpoint"
    }
    envoy_grafana_dashboard = {
      name     = juju_application.envoy.name
      endpoint = "grafana-dashboard"
    }
    envoy_metrics_endpoint = {
      name     = juju_application.envoy.name
      endpoint = "metrics-endpoint"
    }
    kfp_api_grafana_dashboard = {
      name     = juju_application.kfp_api.name
      endpoint = "grafana-dashboard"
    }
    kfp_api_metrics_endpoint = {
      name     = juju_application.kfp_api.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    kfp_api_object_storage = {
      name     = juju_application.kfp_api.name
      endpoint = "object-storage"
    }
    kfp_api_relational_db = {
      name     = juju_application.kfp_api.name
      endpoint = "relational-db"
    }
    kfp_profile_controller_object_storage = {
      name     = juju_application.kfp_profile_controller.name
      endpoint = "object-storage"
    }
    kfp_ui_dashboard_links = {
      name     = juju_application.kfp_ui.name
      endpoint = "dashboard-links"
    }
    kfp_ui_object_storage = {
      name     = juju_application.kfp_ui.name
      endpoint = "object-storage"
    }
    argo_controller_logging = {
      name     = juju_application.argo_controller.name
      endpoint = "logging"
    }
    envoy_logging = {
      name     = juju_application.envoy.name
      endpoint = "logging"
    }
    kfp_api_logging = {
      name     = juju_application.kfp_api.name
      endpoint = "logging"
    }
    kfp_metadata_writer_logging = {
      name     = juju_application.kfp_metadata_writer.name
      endpoint = "logging"
    }
    kfp_persistence_logging = {
      name     = juju_application.kfp_persistence.name
      endpoint = "logging"
    }
    kfp_profile_controller_logging = {
      name     = juju_application.kfp_profile_controller.name
      endpoint = "logging"
    }
    kfp_schedwf_logging = {
      name     = juju_application.kfp_schedwf.name
      endpoint = "logging"
    }
    kfp_ui_logging = {
      name     = juju_application.kfp_ui.name
      endpoint = "logging"
    }
    kfp_viewer_logging = {
      name     = juju_application.kfp_viewer.name
      endpoint = "logging"
    }
    kfp_viz_logging = {
      name     = juju_application.kfp_viz.name
      endpoint = "logging"
    }
    mlmd_logging = {
      name     = juju_application.mlmd.name
      endpoint = "logging"
    }
  }
}

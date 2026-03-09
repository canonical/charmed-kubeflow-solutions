output "dashboard_links_provider" {
  value = {
    app_name = module.kubeflow_dashboard.app_name,
    provides = module.kubeflow_dashboard.provides,
  }
}

output "opentelemetry_collector_k8s" {
  value = var.cos_configuration ? {
    app_name = var.existing_opentelemetry_collector_name == null ? one(juju_application.opentelemetry_collector_k8s[*].name) : var.existing_opentelemetry_collector_name
    provides = {
      grafana_dashboards_provider = "grafana-dashboards-provider",
    }
    requires = {
      send_loki_logs    = "send-loki-logs",
      send_remote_write = "send-remote-write",
    }
  } : null
}

output "kserve_controller" {
  value = {
    app_name = module.kserve_controller.app_name,
    provides = module.kserve_controller.provides,
    requires = module.kserve_controller.requires,
  }
}

output "model" {
  value = var.create_model ? one(juju_model.kubeflow[*].name) : local.kubeflow_platform_model
}


output "grafana_agent_k8s" {
  value = var.cos_configuration ? {
    app_name : var.existing_grafana_agent_name == null ? one(juju_application.grafana_agent_k8s[*].name) : var.existing_grafana_agent_name
    provides : {
      grafana_dashboards_provider : "grafana-dashboards-provider",
    }
    requires : {
      logging_consumer : "logging-consumer",
      send_remote_write : "send-remote-write",
    }
  } : null
}

output "model_name" {
  value = local.model_name
}

output "tls_certificate_requirer" {
  value = {
    app_name : module.istio_pilot.app_name,
    requires : module.istio_pilot.requires.certificates
  }
}

output "grafana_agent_k8s" {
  value = module.kubeflow.grafana_agent_k8s
}

output "model" {
  value = module.kubeflow.model
}

output "resource_dispatcher" {
  value = {
    app_name = module.resource_dispatcher.app_name,
    provides = module.resource_dispatcher.provides,
    requires = module.resource_dispatcher.requires,
  }
}

output "tls_certificate_requirer" {
  value = {
    app_name = module.kubeflow.tls_certificate_requirer.app_name,
    requires = module.kubeflow.tls_certificate_requirer.requires,
  }
}

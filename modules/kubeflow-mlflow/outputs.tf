output "grafana_agent_k8s" {
  value = module.kubeflow.grafana_agent_k8s
}

output "model" {
  value = module.kubeflow.model
}

output "tls_certificate_requirer" {
  value = {
    app_name = module.kubeflow.tls_certificate_requirer.app_name,
    requires = module.kubeflow.tls_certificate_requirer.requires,
  }
}

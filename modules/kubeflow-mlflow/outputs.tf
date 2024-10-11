output "grafana_agent_k8s" {
  value = module.kubeflow.grafana_agent_k8s
}

output "model" {
  value = module.kubeflow.model
}

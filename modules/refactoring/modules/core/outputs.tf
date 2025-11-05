output "offers" {
  description = "Map of all the provided endpoints"
  value = {
    ingress = {
      kind: "endpoint"
      name: juju_application.istio_pilot.name
      endpoint: "ingress"
    }
    dashboard_links = {
      kind: "endpoint"
      name: juju_application.kubeflow_dashboard.name
      endpoint: "links"
    }
  }
}
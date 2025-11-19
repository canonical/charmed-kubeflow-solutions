locals {
  components = {
    istio_pilot = juju_application.istio_pilot
    istio_gateway = juju_application.istio_gateway
    kubeflow_dashboard = juju_application.kubeflow_dashboard
    mlmd = juju_application.mlmd
    envoy = juju_application.envoy
    kubeflow_volumes = juju_application.kubeflow_volumes
    kubeflow_profiles = juju_application.kubeflow_profiles
    oidc_gatekeeper = juju_application.oidc_gatekeeper
    dex_auth = juju_application.dex_auth
    minio = juju_application.minio
    argo_controller = juju_application.argo_controller
    admission_webhook = juju_application.admission_webhook
    kubeflow_roles = juju_application.kubeflow_roles
    metacontroller_operator = juju_application.metacontroller_operator
    pvcviewer_operator = juju_application.pvcviewer_operator
  }

  metrics_endpoints = {
    for name, application in local.components :
    "${name}_metrics" => {
      name: application.name
      endpoint: "metrics"
    }
  }

  grafana_dashboards_endpoints = {
    for name, application in local.components :
    "${name}_dashboard" => {
      name: application.name
      endpoint: "grafana-dashboard"
    }
  }

  logging_endpoints = {
    for name, application in local.components :
    "${name}_logging" => {
      name: application.name
      endpoint: "logging"
    }
  }

  provides = merge({
    ingress = {
      name : juju_application.istio_pilot.name
      endpoint : "ingress"
    }
    dashboard_links = {
      name : juju_application.kubeflow_dashboard.name
      endpoint : "links"
    }
  }, local.metrics_endpoints, local.grafana_dashboards_endpoints)

  requires = merge(local.logging_endpoints)

  offers = {
    for name, endpoint in merge(local.requires, local.provides):
    endpoint.name => endpoint.endpoint if contains(var.expose_endpoints, name)
  }

}
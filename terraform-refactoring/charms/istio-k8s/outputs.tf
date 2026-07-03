# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "application" {
  description = "Object representing the deployed application."
  value       = juju_application.istio_k8s
}

output "provides" {
  description = "Map of provided endpoints."
  value = {
    istio_metadata = {
      name     = juju_application.istio_k8s.name
      endpoint = "istio-metadata"
    }
    grafana_dashboard = {
      name     = juju_application.istio_k8s.name
      endpoint = "grafana-dashboard"
    }
    metrics_endpoint = {
      name     = juju_application.istio_k8s.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of required endpoints."
  value = {
    # istio-k8s requires the ingress configuration provided by each
    # istio-ingress-k8s gateway (interface: istio_ingress_config, no limit).
    # This endpoint is offered cross-model so the gateways in the kubeflow
    # model can attach to the control plane in the istio-system model.
    istio_ingress_config = {
      name     = juju_application.istio_k8s.name
      endpoint = "istio-ingress-config"
    }
    jwks_ca_cert = {
      name     = juju_application.istio_k8s.name
      endpoint = "jwks-ca-cert"
    }
    charm_tracing = {
      name     = juju_application.istio_k8s.name
      endpoint = "charm-tracing"
    }
    workload_tracing = {
      name     = juju_application.istio_k8s.name
      endpoint = "workload-tracing"
    }
  }
}

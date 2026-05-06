# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed core component applications"
  value = {
    admission_webhook  = juju_application.admission_webhook
    kubeflow_dashboard = juju_application.kubeflow_dashboard
    kubeflow_profiles  = juju_application.kubeflow_profiles
    kubeflow_roles     = juju_application.kubeflow_roles
    kubeflow_volumes   = juju_application.kubeflow_volumes
    pvcviewer_operator = juju_application.pvcviewer_operator
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    kubeflow_dashboard_links = {
      name     = juju_application.kubeflow_dashboard.name
      endpoint = "links"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    kubeflow_dashboard_ingress = {
      name     = juju_application.kubeflow_dashboard.name
      endpoint = "ingress"
    }
    kubeflow_volumes_ingress = {
      name     = juju_application.kubeflow_volumes.name
      endpoint = "ingress"
    }
    kubeflow_dashboard_service_mesh = {
      name     = juju_application.kubeflow_dashboard.name
      endpoint = "service-mesh"
    }
    kubeflow_profiles_service_mesh = {
      name     = juju_application.kubeflow_profiles.name
      endpoint = "service-mesh"
    }
    kubeflow_volumes_service_mesh = {
      name     = juju_application.kubeflow_volumes.name
      endpoint = "service-mesh"
    }
    kubeflow_dashboard_istio_ingress_route = {
      name     = juju_application.kubeflow_dashboard.name
      endpoint = "istio-ingress-route"
    }
    kubeflow_volumes_istio_ingress_route = {
      name     = juju_application.kubeflow_volumes.name
      endpoint = "istio-ingress-route"
    }
    pvcviewer_operator_service_mesh = {
      name     = juju_application.pvcviewer_operator.name
      endpoint = "service-mesh"
    }
    pvcviewer_operator_gateway_metadata = {
      name     = juju_application.pvcviewer_operator.name
      endpoint = "gateway-metadata"
    }
    admission_webhook_service_mesh = {
      name     = juju_application.admission_webhook.name
      endpoint = "service-mesh"
    }
  }
}

output "offers" {
  description = "Map of cross-component offer URLs"
  value = {
    kubeflow_dashboard_links = "${juju_application.kubeflow_dashboard.name}:links"
  }
}

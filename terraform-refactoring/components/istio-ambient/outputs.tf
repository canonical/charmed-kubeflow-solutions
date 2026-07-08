# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Istio Ambient applications"
  value = {
    istio_ingress_k8s_ui  = module.istio_ingress_k8s_ui.application
    istio_ingress_k8s_m2m = module.istio_ingress_k8s_m2m.application
    istio_beacon_k8s      = module.istio_beacon_k8s.application
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    # UI gateway
    istio_ingress_k8s_ui_ingress_unauthenticated             = module.istio_ingress_k8s_ui.provides.ingress_unauthenticated
    istio_ingress_k8s_ui_istio_ingress_route                 = module.istio_ingress_k8s_ui.provides.istio_ingress_route
    istio_ingress_k8s_ui_istio_ingress_route_unauthenticated = module.istio_ingress_k8s_ui.provides.istio_ingress_route_unauthenticated
    istio_ingress_k8s_ui_gateway_metadata                    = module.istio_ingress_k8s_ui.provides.gateway_metadata
    istio_ingress_k8s_ui_istio_request_auth                  = module.istio_ingress_k8s_ui.provides.istio_request_auth
    istio_ingress_k8s_ui_metrics_endpoint                    = module.istio_ingress_k8s_ui.provides.metrics_endpoint

    # M2M gateway
    istio_ingress_k8s_m2m_istio_ingress_route                 = module.istio_ingress_k8s_m2m.provides.istio_ingress_route
    istio_ingress_k8s_m2m_istio_ingress_route_unauthenticated = module.istio_ingress_k8s_m2m.provides.istio_ingress_route_unauthenticated
    istio_ingress_k8s_m2m_gateway_metadata                    = module.istio_ingress_k8s_m2m.provides.gateway_metadata
    istio_ingress_k8s_m2m_istio_request_auth                  = module.istio_ingress_k8s_m2m.provides.istio_request_auth
    istio_ingress_k8s_m2m_metrics_endpoint                    = module.istio_ingress_k8s_m2m.provides.metrics_endpoint

    # Beacon
    istio_beacon_k8s_service_mesh     = module.istio_beacon_k8s.provides.service_mesh
    istio_beacon_k8s_provide_cmr_mesh = module.istio_beacon_k8s.provides.provide_cmr_mesh
    istio_beacon_k8s_metrics_endpoint = module.istio_beacon_k8s.provides.metrics_endpoint
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    istio_ingress_k8s_ui_forward_auth  = module.istio_ingress_k8s_ui.requires.forward_auth
    istio_ingress_k8s_m2m_forward_auth = module.istio_ingress_k8s_m2m.requires.forward_auth

    istio_ingress_k8s_ui_certificates  = module.istio_ingress_k8s_ui.requires.certificates
    istio_ingress_k8s_m2m_certificates = module.istio_ingress_k8s_m2m.requires.certificates
  }
}

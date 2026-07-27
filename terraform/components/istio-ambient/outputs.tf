# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed Istio Ambient applications"
  value = {
    istio_ingress_k8s_ui  = { name = module.istio_ingress_k8s_ui.app_name }
    istio_ingress_k8s_m2m = { name = module.istio_ingress_k8s_m2m.app_name }
    istio_beacon_k8s      = { name = module.istio_beacon_k8s.app_name }
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    # UI gateway
    istio_ingress_k8s_ui_ingress_unauthenticated             = { name = module.istio_ingress_k8s_ui.app_name, endpoint = "ingress-unauthenticated" }
    istio_ingress_k8s_ui_istio_ingress_route                 = { name = module.istio_ingress_k8s_ui.app_name, endpoint = "istio-ingress-route" }
    istio_ingress_k8s_ui_istio_ingress_route_unauthenticated = { name = module.istio_ingress_k8s_ui.app_name, endpoint = "istio-ingress-route-unauthenticated" }
    istio_ingress_k8s_ui_gateway_metadata                    = { name = module.istio_ingress_k8s_ui.app_name, endpoint = "gateway-metadata" }
    istio_ingress_k8s_ui_istio_request_auth                  = { name = module.istio_ingress_k8s_ui.app_name, endpoint = "istio-request-auth" }
    istio_ingress_k8s_ui_metrics_endpoint                    = { name = module.istio_ingress_k8s_ui.app_name, endpoint = "metrics-endpoint" }

    # M2M gateway
    istio_ingress_k8s_m2m_istio_ingress_route                 = { name = module.istio_ingress_k8s_m2m.app_name, endpoint = "istio-ingress-route" }
    istio_ingress_k8s_m2m_istio_ingress_route_unauthenticated = { name = module.istio_ingress_k8s_m2m.app_name, endpoint = "istio-ingress-route-unauthenticated" }
    istio_ingress_k8s_m2m_gateway_metadata                    = { name = module.istio_ingress_k8s_m2m.app_name, endpoint = "gateway-metadata" }
    istio_ingress_k8s_m2m_istio_request_auth                  = { name = module.istio_ingress_k8s_m2m.app_name, endpoint = "istio-request-auth" }
    istio_ingress_k8s_m2m_metrics_endpoint                    = { name = module.istio_ingress_k8s_m2m.app_name, endpoint = "metrics-endpoint" }

    # Beacon
    istio_beacon_k8s_service_mesh     = { name = module.istio_beacon_k8s.app_name, endpoint = "service-mesh" }
    istio_beacon_k8s_provide_cmr_mesh = { name = module.istio_beacon_k8s.app_name, endpoint = "provide-cmr-mesh" }
    istio_beacon_k8s_metrics_endpoint = { name = module.istio_beacon_k8s.app_name, endpoint = "metrics-endpoint" }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    istio_ingress_k8s_ui_forward_auth  = { name = module.istio_ingress_k8s_ui.app_name, endpoint = "forward-auth" }
    istio_ingress_k8s_m2m_forward_auth = { name = module.istio_ingress_k8s_m2m.app_name, endpoint = "forward-auth" }

    istio_ingress_k8s_ui_certificates  = { name = module.istio_ingress_k8s_ui.app_name, endpoint = "certificates" }
    istio_ingress_k8s_m2m_certificates = { name = module.istio_ingress_k8s_m2m.app_name, endpoint = "certificates" }
  }
}

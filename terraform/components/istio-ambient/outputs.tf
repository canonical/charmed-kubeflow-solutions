# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  ingress_k8s_relations = {
    for key, gateway in module.istio_ingress_k8s_ui : key => {
      component = { name = gateway.app_name }
      provides = {
        gateway                 = { name = gateway.app_name, endpoint = "gateway" }
        ingress_unauthenticated = { name = gateway.app_name, endpoint = "ingress-unauthenticated" }
        istio_ingress_route     = { name = gateway.app_name, endpoint = "istio-ingress-route" }
        istio_ingress_route_unauthenticated = {
          name     = gateway.app_name
          endpoint = "istio-ingress-route-unauthenticated"
        }
        gateway_metadata   = { name = gateway.app_name, endpoint = "gateway-metadata" }
        istio_request_auth = { name = gateway.app_name, endpoint = "istio-request-auth" }
        metrics_endpoint   = { name = gateway.app_name, endpoint = "metrics-endpoint" }
      }
      requires = {
        forward_auth = { name = gateway.app_name, endpoint = "forward-auth" }
        certificates = { name = gateway.app_name, endpoint = "certificates" }
      }
    }
  }
  ingress_k8s_ui  = local.ingress_k8s_relations["ui"]
  ingress_k8s_m2m = try(local.ingress_k8s_relations["m2m"], null)
}

output "components" {
  description = "Map of the deployed Istio Ambient applications"
  value = {
    istio_k8s = var.istio_ingress_config == null ? {
      name = module.istio_k8s[0].app_name
    } : null
    istio_ingress_k8s = {
      for key, gateway in local.ingress_k8s_relations : key => gateway.component
    }
    istio_ingress_k8s_ui  = local.ingress_k8s_ui.component
    istio_ingress_k8s_m2m = local.ingress_k8s_m2m == null ? null : local.ingress_k8s_m2m.component
    istio_beacon_k8s      = { name = module.istio_beacon_k8s.app_name }
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    istio_ingress_k8s = {
      for key, gateway in local.ingress_k8s_relations : key => gateway.provides
    }

    # Flat aliases preserve the original component output interface.
    istio_ingress_k8s_gateway                                = local.ingress_k8s_ui.provides.gateway
    istio_ingress_k8s_istio_ingress_route                    = local.ingress_k8s_ui.provides.istio_ingress_route
    istio_ingress_k8s_istio_ingress_route_unauthenticated    = local.ingress_k8s_ui.provides.istio_ingress_route_unauthenticated
    istio_ingress_k8s_gateway_metadata                       = local.ingress_k8s_ui.provides.gateway_metadata
    istio_ingress_k8s_ui_ingress_unauthenticated             = local.ingress_k8s_ui.provides.ingress_unauthenticated
    istio_ingress_k8s_ui_istio_ingress_route                 = local.ingress_k8s_ui.provides.istio_ingress_route
    istio_ingress_k8s_ui_istio_ingress_route_unauthenticated = local.ingress_k8s_ui.provides.istio_ingress_route_unauthenticated
    istio_ingress_k8s_ui_gateway_metadata                    = local.ingress_k8s_ui.provides.gateway_metadata
    istio_ingress_k8s_ui_istio_request_auth                  = local.ingress_k8s_ui.provides.istio_request_auth
    istio_ingress_k8s_ui_metrics_endpoint                    = local.ingress_k8s_ui.provides.metrics_endpoint

    istio_ingress_k8s_m2m_istio_ingress_route                 = local.ingress_k8s_m2m == null ? null : local.ingress_k8s_m2m.provides.istio_ingress_route
    istio_ingress_k8s_m2m_istio_ingress_route_unauthenticated = local.ingress_k8s_m2m == null ? null : local.ingress_k8s_m2m.provides.istio_ingress_route_unauthenticated
    istio_ingress_k8s_m2m_gateway_metadata                    = local.ingress_k8s_m2m == null ? null : local.ingress_k8s_m2m.provides.gateway_metadata
    istio_ingress_k8s_m2m_istio_request_auth                  = local.ingress_k8s_m2m == null ? null : local.ingress_k8s_m2m.provides.istio_request_auth
    istio_ingress_k8s_m2m_metrics_endpoint                    = local.ingress_k8s_m2m == null ? null : local.ingress_k8s_m2m.provides.metrics_endpoint

    istio_beacon_k8s_service_mesh     = { name = module.istio_beacon_k8s.app_name, endpoint = "service-mesh" }
    istio_beacon_k8s_provide_cmr_mesh = { name = module.istio_beacon_k8s.app_name, endpoint = "provide-cmr-mesh" }
    istio_beacon_k8s_metrics_endpoint = { name = module.istio_beacon_k8s.app_name, endpoint = "metrics-endpoint" }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    istio_ingress_k8s = {
      for key, gateway in local.ingress_k8s_relations : key => gateway.requires
    }

    # Flat aliases preserve the original component output interface.
    istio_ingress_k8s_forward_auth     = local.ingress_k8s_ui.requires.forward_auth
    istio_ingress_k8s_ui_forward_auth  = local.ingress_k8s_ui.requires.forward_auth
    istio_ingress_k8s_m2m_forward_auth = local.ingress_k8s_m2m == null ? null : local.ingress_k8s_m2m.requires.forward_auth
    istio_ingress_k8s_ui_certificates  = local.ingress_k8s_ui.requires.certificates
    istio_ingress_k8s_m2m_certificates = local.ingress_k8s_m2m == null ? null : local.ingress_k8s_m2m.requires.certificates
  }
}

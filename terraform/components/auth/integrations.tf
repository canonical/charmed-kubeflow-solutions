# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Internal relations (within this component)

# Dex Auth to OIDC Gatekeeper OIDC config
resource "juju_integration" "dex_auth_oidc_gatekeeper_dex_oidc_config" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.dex_auth.name
    endpoint = "dex-oidc-config"
  }

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "dex-oidc-config"
  }
}

# Dex Auth to OIDC Gatekeeper OIDC client
resource "juju_integration" "dex_auth_oidc_gatekeeper_oidc_client" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.dex_auth.name
    endpoint = "oidc-client"
  }

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "oidc-client"
  }
}

# External ingress integrations (istio-pilot:ingress -> auth apps)

resource "juju_integration" "dex_auth_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.dex_auth.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

resource "juju_integration" "oidc_gatekeeper_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# External ingress-auth integration (istio-pilot:ingress-auth -> oidc-gatekeeper)

resource "juju_integration" "oidc_gatekeeper_ingress_auth" {
  count      = var.ingress_auth != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "ingress-auth"
  }

  application {
    name      = var.ingress_auth.kind == "endpoint" ? var.ingress_auth.name : null
    endpoint  = var.ingress_auth.kind == "endpoint" ? var.ingress_auth.endpoint : null
    offer_url = var.ingress_auth.kind == "offer" ? var.ingress_auth.url : null
  }
}

# Ambient service-mesh integrations (istio-beacon-k8s:service-mesh -> auth apps)

resource "juju_integration" "dex_auth_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.dex_auth.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "oidc_gatekeeper_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

# Ambient istio-ingress-route-unauthenticated integrations (istio-ingress-k8s:istio-ingress-route-unauthenticated -> auth apps)

resource "juju_integration" "oidc_gatekeeper_istio_ingress_route_unauthenticated" {
  count      = var.istio_ingress_route_unauthenticated != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "istio-ingress-route-unauthenticated"
  }

  application {
    name      = var.istio_ingress_route_unauthenticated.kind == "endpoint" ? var.istio_ingress_route_unauthenticated.name : null
    endpoint  = var.istio_ingress_route_unauthenticated.kind == "endpoint" ? var.istio_ingress_route_unauthenticated.endpoint : null
    offer_url = var.istio_ingress_route_unauthenticated.kind == "offer" ? var.istio_ingress_route_unauthenticated.url : null
  }
}

resource "juju_integration" "dex_auth_istio_ingress_route_unauthenticated" {
  count      = var.istio_ingress_route_unauthenticated != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.dex_auth.name
    endpoint = "istio-ingress-route-unauthenticated"
  }

  application {
    name      = var.istio_ingress_route_unauthenticated.kind == "endpoint" ? var.istio_ingress_route_unauthenticated.name : null
    endpoint  = var.istio_ingress_route_unauthenticated.kind == "endpoint" ? var.istio_ingress_route_unauthenticated.endpoint : null
    offer_url = var.istio_ingress_route_unauthenticated.kind == "offer" ? var.istio_ingress_route_unauthenticated.url : null
  }
}

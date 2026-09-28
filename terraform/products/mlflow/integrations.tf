# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# forward-auth (ambient-iam): oauth2-proxy -> UI gateway (istio-ingress-k8s-ui).
# Browser sessions on the UI gateway are authenticated by oauth2-proxy, which
# federates to Hydra (iam model) through the oauth cross-model offer.
resource "juju_integration" "oauth2_proxy_ui_forward_auth" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = module.oauth2_proxy[0].provides.forward_auth.name
    endpoint = module.oauth2_proxy[0].provides.forward_auth.endpoint
  }

  application {
    name     = module.ambient_iam[0].requires.istio_ingress_k8s_ui_forward_auth.name
    endpoint = module.ambient_iam[0].requires.istio_ingress_k8s_ui_forward_auth.endpoint
  }
}

# oauth2-proxy is reachable unauthenticated on the UI gateway (it is the
# authenticator for the login flow): oauth2-proxy:ingress -> UI gateway's
# ingress-unauthenticated.
resource "juju_integration" "oauth2_proxy_ui_ingress" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = module.oauth2_proxy[0].requires.ingress.name
    endpoint = module.oauth2_proxy[0].requires.ingress.endpoint
  }

  application {
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_ui_ingress_unauthenticated.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_ui_ingress_unauthenticated.endpoint
  }
}

# request-authentication (ambient-iam): request-authentication-configurator
# installs Istio RequestAuthentication (JWT validation) on each gateway.
resource "juju_integration" "request_auth_ui" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = module.request_authentication_configurator[0].requires.request_auth_ui.name
    endpoint = module.request_authentication_configurator[0].requires.request_auth_ui.endpoint
  }

  application {
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_ui_istio_request_auth.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_ui_istio_request_auth.endpoint
  }
}

resource "juju_integration" "request_auth_m2m" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = module.request_authentication_configurator[0].requires.request_auth_m2m.name
    endpoint = module.request_authentication_configurator[0].requires.request_auth_m2m.endpoint
  }

  application {
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_istio_request_auth.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_istio_request_auth.endpoint
  }
}

# github-profiles-automator joins the in-model service mesh (ambient-iam).
resource "juju_integration" "github_profiles_automator_service_mesh" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = module.github_profiles_automator[0].requires.service_mesh.name
    endpoint = module.github_profiles_automator[0].requires.service_mesh.endpoint
  }

  application {
    name     = module.ambient_iam[0].provides.istio_beacon_k8s_service_mesh.name
    endpoint = module.ambient_iam[0].provides.istio_beacon_k8s_service_mesh.endpoint
  }
}

# TLS certificates (ambient-iam): self-signed-certificates -> both gateways.
resource "juju_integration" "istio_ingress_ui_certificates" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = juju_application.self_signed_certificates[0].name
    endpoint = "certificates"
  }

  application {
    name     = module.ambient_iam[0].requires.istio_ingress_k8s_ui_certificates.name
    endpoint = module.ambient_iam[0].requires.istio_ingress_k8s_ui_certificates.endpoint
  }
}

resource "juju_integration" "istio_ingress_m2m_certificates" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = juju_application.self_signed_certificates[0].name
    endpoint = "certificates"
  }

  application {
    name     = module.ambient_iam[0].requires.istio_ingress_k8s_m2m_certificates.name
    endpoint = module.ambient_iam[0].requires.istio_ingress_k8s_m2m_certificates.endpoint
  }
}

resource "juju_integration" "mlflow_server_m2m_istio_ingress_route" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = module.mlflow[0].components.mlflow_server.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_istio_ingress_route.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_istio_ingress_route.endpoint
  }
}

resource "juju_integration" "mlflow_server_ui_istio_ingress_route" {
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  application {
    name     = module.mlflow[0].components.mlflow_server.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_ui_istio_ingress_route.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_ui_istio_ingress_route.endpoint
  }
}

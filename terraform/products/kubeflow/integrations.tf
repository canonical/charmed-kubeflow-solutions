# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Most cross-component integrations are handled by passing outputs from the
# istio/ambient modules as inputs to downstream component modules.
# See main.tf for the wiring of service_mesh, istio_ingress_route, and
# istio_ingress_route_unauthenticated into module "core".

# forward-auth (ambient-dex): oidc-gatekeeper (auth) -> the single ambient
# gateway. On the ambient-iam path this is replaced by the IAM stack below.
resource "juju_integration" "oidc_gatekeeper_istio_ingress_forward_auth" {
  count      = var.service_mesh_type == "ambient-dex" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.auth[0].provides.oidc_gatekeeper_forward_auth.name
    endpoint = module.auth[0].provides.oidc_gatekeeper_forward_auth.endpoint
  }

  application {
    name     = module.ambient_dex[0].requires.istio_ingress_k8s_forward_auth.name
    endpoint = module.ambient_dex[0].requires.istio_ingress_k8s_forward_auth.endpoint
  }
}

# forward-auth (ambient-iam): oauth2-proxy -> UI gateway (istio-ingress-k8s-ui).
# Browser sessions on the UI gateway are authenticated by oauth2-proxy, which
# federates to Hydra (iam model) through the oauth cross-model offer.
resource "juju_integration" "oauth2_proxy_ui_forward_auth" {
  count      = var.service_mesh_type == "ambient-iam" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

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
  count      = var.service_mesh_type == "ambient-iam" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

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
  count      = var.service_mesh_type == "ambient-iam" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

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
  count      = var.service_mesh_type == "ambient-iam" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

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
  count      = var.service_mesh_type == "ambient-iam" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

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
  count      = var.service_mesh_type == "ambient-iam" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

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
  count      = var.service_mesh_type == "ambient-iam" ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = juju_application.self_signed_certificates[0].name
    endpoint = "certificates"
  }

  application {
    name     = module.ambient_iam[0].requires.istio_ingress_k8s_m2m_certificates.name
    endpoint = module.ambient_iam[0].requires.istio_ingress_k8s_m2m_certificates.endpoint
  }
}

# Dual-gateway fronting (ambient): kfp-ui and mlflow-operator are also fronted by
# the M2M gateway (token/JWT clients), in addition to the UI gateway wired by
# their component modules. The istio-ingress-route requirer endpoint has no
# limit, so a second relation to the M2M gateway is permitted.
resource "juju_integration" "kfp_ui_m2m_istio_ingress_route" {
  count      = (var.service_mesh_type == "ambient-iam" && var.enable_kfp) ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.kfp[0].components.kfp_ui.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_istio_ingress_route.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_istio_ingress_route.endpoint
  }
}

resource "juju_integration" "mlflow_server_m2m_istio_ingress_route" {
  count      = (var.service_mesh_type == "ambient-iam" && var.enable_mlflow) ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.mlflow[0].components.mlflow_server.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_istio_ingress_route.name
    endpoint = module.ambient_iam[0].provides.istio_ingress_k8s_m2m_istio_ingress_route.endpoint
  }
}

# minio service-mesh integration (any ambient mode)
resource "juju_integration" "minio_service_mesh" {
  count      = (local.deploy_minio && local.ambient) ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.minio[0].requires.service_mesh.name
    endpoint = module.minio[0].requires.service_mesh.endpoint
  }

  application {
    name     = local.beacon.name
    endpoint = local.beacon.endpoint
  }
}

# kserve-controller object-storage integration (minio:object-storage -> kserve-controller)
# Only deployed when MLflow is enabled, since kserve uses minio to read MLflow model artifacts
resource "juju_integration" "kserve_controller_object_storage" {
  count      = (var.enable_mlflow && var.enable_kserve) ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.kserve[0].requires.kserve_controller_object_storage.name
    endpoint = module.kserve[0].requires.kserve_controller_object_storage.endpoint
  }

  application {
    name     = module.minio[0].provides.object_storage.name
    endpoint = module.minio[0].provides.object_storage.endpoint
  }
}

# resource-dispatcher service-mesh integration (any ambient mode)
resource "juju_integration" "resource_dispatcher_service_mesh" {
  count      = ((var.enable_mlflow || var.enable_feast) && local.ambient) ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.resource_dispatcher[0].requires.service_mesh.name
    endpoint = module.resource_dispatcher[0].requires.service_mesh.endpoint
  }

  application {
    name     = local.beacon.name
    endpoint = local.beacon.endpoint
  }
}

# kserve-controller secrets integration (resource-dispatcher:secrets -> kserve-controller)
# Only deployed when MLflow is enabled
resource "juju_integration" "kserve_controller_secrets" {
  count      = var.enable_mlflow ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.kserve[0].requires.kserve_controller_secrets.name
    endpoint = module.kserve[0].requires.kserve_controller_secrets.endpoint
  }

  application {
    name     = module.resource_dispatcher[0].provides.secrets.name
    endpoint = module.resource_dispatcher[0].provides.secrets.endpoint
  }
}

# kserve-controller service-accounts integration (resource-dispatcher:pod-defaults -> kserve-controller:service-accounts)
# Only deployed when MLflow is enabled
resource "juju_integration" "kserve_controller_service_accounts" {
  count      = var.enable_mlflow ? 1 : 0
  model_uuid = var.create_model ? juju_model.kubeflow[0].uuid : var.model_uuid

  application {
    name     = module.kserve[0].requires.kserve_controller_service_accounts.name
    endpoint = module.kserve[0].requires.kserve_controller_service_accounts.endpoint
  }

  application {
    name     = module.resource_dispatcher[0].provides.pod_defaults.name
    endpoint = module.resource_dispatcher[0].provides.pod_defaults.endpoint
  }
}


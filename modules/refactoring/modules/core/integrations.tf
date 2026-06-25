resource "juju_integration" "argo_controller_minio" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.argo_controller.name
    endpoint = "object-storage"
  }

  application {
    name     = juju_application.minio.name
    endpoint = "object-storage"
  }
}

resource "juju_integration" "dex_auth_oidc_gatekeeper_dex_oidc_config" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.dex_auth.name
    endpoint = "dex-oidc-config"
  }

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "dex-oidc-config"
  }
}

resource "juju_integration" "dex_auth_oidc_gatekeeper_oidc_client" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.dex_auth.name
    endpoint = "oidc-client"
  }

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "oidc-client"
  }
}

resource "juju_integration" "istio_pilot_dex_auth_ingress" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.istio_pilot.name
    endpoint = "ingress"
  }

  application {
    name     = juju_application.dex_auth.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "istio_pilot_kubeflow_dashboard_ingress" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.istio_pilot.name
    endpoint = "ingress"
  }

  application {
    name     = juju_application.kubeflow_dashboard.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "istio_pilot_kubeflow_volumes_ingress" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.istio_pilot.name
    endpoint = "ingress"
  }

  application {
    name     = juju_application.kubeflow_volumes.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "istio_pilot_oidc_gatekeeper_ingress" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.istio_pilot.name
    endpoint = "ingress"
  }

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "istio_pilot_envoy_ingress" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.istio_pilot.name
    endpoint = "ingress"
  }

  application {
    name     = juju_application.envoy.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "istio_pilot_oidc_gatekeeper_ingress_auth" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.istio_pilot.name
    endpoint = "ingress-auth"
  }

  application {
    name     = juju_application.oidc_gatekeeper.name
    endpoint = "ingress-auth"
  }
}

resource "juju_integration" "istio_pilot_istio_gateway_istio_pilot" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.istio_pilot.name
    endpoint = "istio-pilot"
  }

  application {
    name     = juju_application.istio_gateway.name
    endpoint = "istio-pilot"
  }
}

resource "juju_integration" "kubeflow_profiles_kubeflow_dashboard_kubeflow_profiles" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.kubeflow_profiles.name
    endpoint = "kubeflow-profiles"
  }

  application {
    name     = juju_application.kubeflow_dashboard.name
    endpoint = "kubeflow-profiles"
  }
}

resource "juju_integration" "kubeflow_dashboard_kubeflow_volumes_links" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.kubeflow_dashboard.name
    endpoint = "links"
  }

  application {
    name     = juju_application.kubeflow_volumes.name
    endpoint = "dashboard-links"
  }
}

resource "juju_integration" "mlmd_envoy_grpc" {
  model_uuid = data.juju_model.kubeflow.uuid

  application {
    name     = juju_application.mlmd.name
    endpoint = "grpc"
  }

  application {
    name     = juju_application.envoy.name
    endpoint = "grpc"
  }
}
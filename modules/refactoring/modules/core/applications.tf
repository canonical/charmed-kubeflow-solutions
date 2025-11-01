data "juju_model" "kubeflow" {
  name = var.model
  owner = "admin"
}

resource "juju_application" "admission_webhook" {
  charm {
    name     = "admission-webhook"
    channel  = var.admission_webhook.channel != null ? var.admission_webhook.channel : "1.10/${var.risk}"
    revision = var.admission_webhook.revision
  }
  config             = var.admission_webhook.config
  constraints        = var.admission_webhook.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.admission_webhook.name
}

resource "juju_application" "argo_controller" {
  charm {
    name     = "argo-controller"
    channel  = var.argo_controller.channel != null ? var.argo_controller.channel : "3.5/${var.risk}"
    revision = var.argo_controller.revision
  }
  config             = var.argo_controller.config
  constraints        = var.argo_controller.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.argo_controller.name
}

resource "juju_application" "dex_auth" {
  charm {
    name     = "dex-auth"
    channel  = var.dex_auth.channel != null ? var.dex_auth.channel : "2.41/${var.risk}"
    revision = var.dex_auth.revision
  }
  config             = var.dex_auth.config
  constraints        = var.dex_auth.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.dex_auth.name
}

resource "juju_application" "envoy" {
  charm {
    name     = "envoy"
    channel  = var.envoy.channel != null ? var.envoy.channel : "2.4/${var.risk}"
    revision = var.envoy.revision
  }
  config             = var.envoy.config
  constraints        = var.envoy.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.envoy.name
}

resource "juju_application" "istio_ingressgateway" {
  charm {
    name     = "istio-ingressgateway"
    channel  = var.istio_ingressgateway.channel != null ? var.istio_ingressgateway.channel : "1.24/${var.risk}"
    revision = var.istio_ingressgateway.revision
  }
  config             = var.istio_ingressgateway.config
  constraints        = var.istio_ingressgateway.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.istio_ingressgateway.name
}


resource "juju_application" "istio_pilot" {
  charm {
    name     = "istio-pilot"
    channel  = var.istio_pilot.channel != null ? var.istio_pilot.channel : "1.24/${var.risk}"
    revision = var.istio_pilot.revision
  }
  config             = var.istio_pilot.config
  constraints        = var.istio_pilot.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.istio_pilot.name
}

resource "juju_application" "kubeflow_dashboard" {
  charm {
    name     = "kubeflow-dashboard"
    channel  = var.kubeflow_dashboard.channel != null ? var.kubeflow_dashboard.channel : "1.10/${var.risk}"
    revision = var.kubeflow_dashboard.revision
  }
  config             = var.kubeflow_dashboard.config
  constraints        = var.kubeflow_dashboard.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.kubeflow_dashboard.name
}

resource "juju_application" "kubeflow_profiles" {
  charm {
    name     = "kubeflow-profiles"
    channel  = var.kubeflow_profiles.channel != null ? var.kubeflow_profiles.channel : "1.10/${var.risk}"
    revision = var.kubeflow_profiles.revision
  }
  config             = var.kubeflow_profiles.config
  constraints        = var.kubeflow_profiles.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.kubeflow_profiles.name
}

resource "juju_application" "kubeflow_roles" {
  charm {
    name     = "kubeflow-roles"
    channel  = var.kubeflow_roles.channel != null ? var.kubeflow_roles.channel : "1.10/${var.risk}"
    revision = var.kubeflow_roles.revision
  }
  config             = var.kubeflow_roles.config
  constraints        = var.kubeflow_roles.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.kubeflow_roles.name
}

resource "juju_application" "kubeflow_volumes" {
  charm {
    name     = "kubeflow-volumes"
    channel  = var.kubeflow_volumes.channel != null ? var.kubeflow_volumes.channel : "1.10/${var.risk}"
    revision = var.kubeflow_volumes.revision
  }
  config             = var.kubeflow_volumes.config
  constraints        = var.kubeflow_volumes.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.kubeflow_volumes.name
}

resource "juju_application" "metacontroller_operator" {
  charm {
    name     = "metacontroller-operator"
    channel  = var.metacontroller_operator.channel != null ? var.metacontroller_operator.channel : "4.11/${var.risk}"
    revision = var.metacontroller_operator.revision
  }
  config             = var.metacontroller_operator.config
  constraints        = var.metacontroller_operator.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  # storage_directives = var.admission_webhook.storage_directives
  trust              = true
  units              = 1
  name      = var.metacontroller_operator.name
}

resource "juju_application" "mlmd" {
  charm {
    name     = "mlmd"
    channel  = var.mlmd.channel != null ? var.mlmd.channel : "ckf-1.10/${var.risk}"
    revision = var.mlmd.revision
  }
  config             = var.mlmd.config
  constraints        = var.mlmd.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  storage_directives = var.mlmd.storage_directives
  trust              = true
  units              = 1
  name      = var.mlmd.name
}

resource "juju_application" "minio" {
  charm {
    name     = "minio"
    channel  = var.minio.channel != null ? var.minio.channel : "ckf-1.10/${var.risk}"
    revision = var.minio.revision
  }
  config             = var.minio.config
  constraints        = var.minio.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  storage_directives = var.minio.storage_directives
  trust              = true
  units              = 1
  name      = var.minio.name
}

resource "juju_application" "oidc_gatekeeper" {
  charm {
    name     = "oidc-gatekeeper"
    channel  = var.oidc_gatekeeper.channel != null ? var.oidc_gatekeeper.channel : "ckf-1.10/${var.risk}"
    revision = var.oidc_gatekeeper.revision
  }
  config             = var.oidc_gatekeeper.config
  constraints        = var.oidc_gatekeeper.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.oidc_gatekeeper.name
}

resource "juju_application" "pvcviewer_operator" {
  charm {
    name     = "pvcviewer-operator"
    channel  = var.pvcviewer_operator.channel != null ? var.pvcviewer_operator.channel : "1.10/${var.risk}"
    revision = var.pvcviewer_operator.revision
  }
  config             = var.pvcviewer_operator.config
  constraints        = var.pvcviewer_operator.constraints
  model_uuid         = data.juju_model.kubeflow.uuid
  trust              = true
  units              = 1
  name      = var.pvcviewer_operator.name
}


# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "mlflow" {
  count = var.create_model ? 1 : 0
  name  = "mlflow"

  config = {
    juju-http-proxy  = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy    = var.no_proxy
  }
}

# === Ambient service mesh =================================================
# Unlike Kubeflow, only one ambient submode allowed:
#  - ambient-iam: two gateways (UI/M2M) + beacon here; istio-k8s runs in the
#    istio-system model (cross-model istio-ingress-config offer); IAM auth.

module "ambient_iam" {
  count  = 1
  source = "../../components/istio-ambient"

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  istio_ingress_k8s = {
    channel  = local.istio_ingress_k8s_channel
    revision = var.istio_ingress_k8s_revision
    config   = var.istio_ingress_k8s_config
  }
  istio_ingress_k8s_ui_config  = var.istio_ingress_k8s_ui_config
  istio_ingress_k8s_m2m_config = var.istio_ingress_k8s_m2m_config

  istio_beacon_k8s = {
    channel  = local.istio_beacon_k8s_channel
    revision = var.istio_beacon_k8s_revision
    config   = var.istio_beacon_k8s_config
  }

  # The offer URL is only known after apply (it comes from a juju_offer in the
  # istio-system model), so this object is gated on the known service_mesh_type
  # rather than on the URL value — otherwise the gateways' integration count
  # would depend on an unknown value.
  istio_ingress_config = {
    kind = "offer"
    url  = var.istio_ingress_config_offer_url
  }
}

# === IAM forward-auth + request-auth stack (ambient only) ===================
# oauth2-proxy provides browser session forward-auth to the UI gateway.
# request-authentication-configurator installs JWT RequestAuthentication on both
# gateways. Both consume Hydra oauth from the iam model cross-model.

module "oauth2_proxy" {
  count  = 1
  source = "../../charms/oauth2-proxy-k8s"

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid
  channel    = local.oauth2_proxy_channel
  revision   = var.oauth2_proxy_revision
  config = merge({
    # Forward the verified identity to upstream apps as an Authorization header.
    set_authorization_header = true
    dev                      = true
    enable_jwt_bearer_tokens = true
  }, var.oauth2_proxy_config)

  # Gated on the known mode (not the offer URL, which is only known
  # after apply) so oauth2-proxy's oauth integration count is plan-determinable.
  oauth = {
    kind = "offer"
    url  = var.oauth_offer_url
  }

  # Trust the self-signed CA fronting the Identity Platform via the send-ca-cert
  # offer from the iam-core model. Gated on the known mode so the
  # integration count is plan-determinable.
  ca_cert = {
    kind = "offer"
    url  = var.send_ca_cert_offer_url
  }
}

module "request_authentication_configurator" {
  count  = 1
  source = "../../charms/request-authentication-configurator"

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid
  channel    = local.request_authentication_configurator_channel
  revision   = var.request_authentication_configurator_revision
  config = merge({
    # JWT claim carrying the user identity, exposed downstream as this header.
    "user-id-header-name" = "mlflow-userid"
  }, var.request_authentication_configurator_config)

  # Gated on the known mode (not the offer URL, which is only known
  # after apply) so the oauth integration count is plan-determinable.
  oauth = {
    kind = "offer"
    url  = var.oauth_offer_url
  }
}

# TLS certificates for the ambient gateways. Provides the `certificates`
# relation consumed by both istio-ingress-k8s gateways.
resource "juju_application" "self_signed_certificates" {
  count = 1

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid
  name       = "self-signed-certificates"

  charm {
    name     = "self-signed-certificates"
    channel  = var.self_signed_certificates_channel
    revision = var.self_signed_certificates_revision
    base     = "ubuntu@22.04"
  }

  config = var.self_signed_certificates_config
  trust  = true
  units  = 1
}

## Object storage (shared S3 integrator)

resource "juju_secret" "s3_secret_global" {
  depends_on = [juju_model.mlflow]
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid
  name       = "s3_secret_global"
  value = {
    secret-key = var.s3_secret_key_global
    access-key = var.s3_access_key_global
  }
  info = "This is the access key and secret key for the S3 storage"
}

module "s3_global" {
  depends_on = [juju_model.mlflow, juju_secret.s3_secret_global]
  count      = 1
  source     = "../../charms/s3-integrator"

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  app_name   = "s3-integrator-global"
  offer_name = "s3-credentials-global"
  channel    = local.s3_integrator_channel
  config = merge(
    {
      bucket      = var.s3_bucket_global,
      endpoint    = var.s3_endpoint_global,
      credentials = "secret:${juju_secret.s3_secret_global[0].secret_id}"
    },
    var.s3_tls_ca_chain_global != "" ? { "tls-ca-chain" = base64encode(var.s3_tls_ca_chain_global) } : {},
    var.s3_config_global
  )
  constraints = "arch=amd64"
  revision    = var.s3_revision_global
}

resource "juju_access_secret" "s3_secret_access_global" {
  depends_on = [juju_model.mlflow, juju_secret.s3_secret_global, module.s3_global]
  count      = 1
  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  applications = [
    module.s3_global[0].application.name
  ]
  secret_id = juju_secret.s3_secret_global[0].secret_id
}

module "mlflow" {
  count      = 1
  depends_on = [module.ambient_iam, module.s3_global, module.postgresql]

  source = "../../components/mlflow"

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  dashboard_links = null

  postgresql_database = {
    kind     = "endpoint"
    name     = module.postgresql[0].app_name
    endpoint = module.postgresql[0].provides.database
  }

  s3_credentials = {
    kind     = "endpoint"
    name     = module.s3_global[0].provides.s3_credentials.name
    endpoint = module.s3_global[0].provides.s3_credentials.endpoint
  }

  secrets = null

  pod_defaults = null

  service_mesh        = local.service_mesh
  istio_ingress_route = local.ui_istio_ingress_route

  mlflow_server = {
    channel  = local.mlflow_channel
    revision = var.mlflow_server_revision
    config   = var.mlflow_server_config
  }
}

module "postgresql" {
  count      = 1
  depends_on = [module.ambient_iam]

  source = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=b7822d93f8d5d0d94ca3da36ea9f5b13f3e58d43"

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid
  app_name   = "postgresql"
  channel    = "14/stable"
  revision   = var.postgresql_revision
  config     = var.postgresql_config
  storage_directives = {
    pgdata = var.postgresql_storage_size
  }
}

module "data_integrator_integrations" {
  for_each = var.user_grants_across_workspaces

  source = "../../components/data-integrator"

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  data_integrator = {
    app_name = each.key,
    config = {
      "entity-name"        = each.value.entity_name,
      "entity-permissions" = each.value.entity_permissions
    }
  }

  mlflow_server_endpoint = {
    name     = module.mlflow[0].application.name
    endpoint = "mlflow_client"
  }
}

module "observability" {
  count = var.enable_observability ? 1 : 0
  depends_on = [module.ambient_iam, module.mlflow]

  source = "../../components/observability"

  model_uuid = var.create_model ? juju_model.mlflow[0].uuid : var.model_uuid

  dashboards_offer = var.dashboards_offer
  logging_offer    = var.logging_offer
  metrics_offer    = var.metrics_offer

  opentelemetry_collector_k8s = {
    revision = var.opentelemetry_collector_k8s_revision
    config   = var.opentelemetry_collector_k8s_config
  }

  # Service mesh (ambient only)
  service_mesh = local.beacon

  # MLflow
  mlflow_server_grafana_dashboard = module.mlflow[0].provides.mlflow_server_grafana_dashboard
  mlflow_server_metrics_endpoint  = module.mlflow[0].provides.mlflow_server_metrics_endpoint
  mlflow_server_logging           = module.mlflow[0].requires.mlflow_server_logging
}

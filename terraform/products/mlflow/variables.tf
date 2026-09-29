# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Juju Settings

variable "release" {
  type        = string
  description = "MLflow release to deploy. Use 'latest' for latest tracks or '1.11' for pinned 1.11 tracks."
  default     = "latest"

  validation {
    condition     = contains(["1.11", "latest"], var.release)
    error_message = "Valid values for var: release are (1.11 and latest)."
  }
}

variable "risk" {
  type        = string
  description = "Value for the risk to be used"
  default     = "edge"

  validation {
    condition     = contains(["stable", "candidate", "beta", "edge"], var.risk)
    error_message = "Valid values for var: risk are (stable, candidate, beta and edge)."
  }
}

variable "create_model" {
  description = "Create a Juju model named mlflow for this product deployment"
  type        = bool
  default     = true
}

variable "model_uuid" {
  description = "UUID of an existing Juju model (required when create_model is false)"
  type        = string
  default     = null

  validation {
    condition     = var.create_model || var.model_uuid != null
    error_message = "model_uuid must be provided when create_model is false."
  }
}

# S3 Integrator (shared/global) variables

variable "s3_secret_key_global" {
  description = "S3 secret key for the shared object storage integration"
  type        = string
  default     = ""
  sensitive   = true
}

variable "s3_access_key_global" {
  description = "S3 access key for the shared object storage integration"
  type        = string
  default     = ""
  sensitive   = true
}

variable "s3_endpoint_global" {
  description = "S3 endpoint for the shared object storage integration"
  type        = string
  default     = ""
}

variable "s3_bucket_global" {
  description = "S3 bucket for the shared object storage integration"
  type        = string
  default     = ""
}

variable "s3_config_global" {
  description = "Configuration for the shared s3-integrator application"
  type        = map(string)
  default     = {}
}

variable "s3_tls_ca_chain_global" {
  description = "PEM-encoded CA chain used for HTTPS validation against the S3 endpoint. When set, it is base64-encoded and passed to the s3-integrator 'tls-ca-chain' config option. Leave empty to omit."
  type        = string
  default     = ""
}

variable "s3_revision_global" {
  description = "Revision of the shared s3-integrator application"
  type        = number
  default     = null
}

# Ambient Component Applications

variable "istio_ingress_k8s_revision" {
  description = "Revision of the istio-ingress-k8s application"
  type        = number
  default     = null
}

variable "istio_ingress_k8s_config" {
  description = "Configuration for istio-ingress-k8s application"
  type        = map(string)
  default     = {}
}

variable "istio_beacon_k8s_revision" {
  description = "Revision of the istio-beacon-k8s application"
  type        = number
  default     = null
}

variable "istio_beacon_k8s_config" {
  description = "Configuration for istio-beacon-k8s application"
  type        = map(string)
  default     = {}
}

variable "istio_ingress_k8s_ui_config" {
  description = "Extra configuration for the UI istio-ingress-k8s gateway (merged over istio_ingress_k8s_config)"
  type        = map(string)
  default     = {}
}

variable "istio_ingress_k8s_m2m_config" {
  description = "Extra configuration for the M2M istio-ingress-k8s gateway (merged over istio_ingress_k8s_config)"
  type        = map(string)
  default     = {}
}

variable "istio_ingress_config_offer_url" {
  description = <<-EOT
    Cross-model offer URL of istio-k8s:istio-ingress-config from the
    istio-system model. The UI ambient gateway consumes this offer. Required when
    service_mesh_type is 'ambient'.
  EOT
  type        = string
  default     = null
}

# Self-signed certificates for the ambient gateways

variable "self_signed_certificates_channel" {
  description = "Channel for the self-signed-certificates charm serving the ambient gateways."
  type        = string
  default     = "1/stable"
  nullable    = false
}

variable "self_signed_certificates_revision" {
  description = "Revision of the self-signed-certificates application."
  type        = number
  default     = null
}

variable "self_signed_certificates_config" {
  description = "Configuration for the self-signed-certificates application."
  type        = map(string)
  default     = {}
}

# IAM Auth Applications (ambient only)

variable "oauth_offer_url" {
  description = <<-EOT
    Cross-model offer URL of hydra:oauth from the iam model. Consumed by
    oauth2-proxy and request-authentication-configurator. Required when
    service_mesh_type is 'ambient'.
  EOT
  type        = string
  default     = null
}

variable "send_ca_cert_offer_url" {
  description = <<-EOT
    Cross-model offer URL of self-signed-certificates:send-ca-cert from the
    iam-core model. Consumed by oauth2-proxy on receive-ca-cert to trust the
    self-signed CA fronting the Identity Platform. Required when
    service_mesh_type is 'ambient'.
  EOT
  type        = string
  default     = null
}

variable "oauth2_proxy_revision" {
  description = "Revision of the oauth2-proxy-k8s application"
  type        = number
  default     = null
}

variable "oauth2_proxy_config" {
  description = "Configuration for the oauth2-proxy-k8s application"
  type        = map(string)
  default     = {}
}

variable "request_authentication_configurator_revision" {
  description = "Revision of the request-authentication-configurator application"
  type        = number
  default     = null
}

variable "request_authentication_configurator_config" {
  description = "Configuration for the request-authentication-configurator application"
  type        = map(string)
  default     = {}
}

variable "user_grants_across_workspaces" {
  description = <<-EOT
    Grants for all MLflow users across MLflow workspaces in terms of data-integrator instances,
    with each item of a list representing grants across all workspaces for a given user, and
    with each key representing the instance's name and the corresponding value the respective
    instance's relevant configurations for MLflow
  EOT
  type = map(object({
    entity_name        = string
    entity_permissions = string
  }))
  default = {}
}

variable "mlflow_server_revision" {
  description = "Revision of the mlflow-server application"
  type        = number
  default     = 1579
  # TODO: restore `null` instead of `1579` once multi-tenancy is merged
}

variable "mlflow_server_config" {
  description = "Configuration for mlflow-server application"
  type        = map(string)
  default = {
    "identity_header_name" = "mlflow-userid"
  }
}

# Observability Component

variable "enable_observability" {
  description = "Whether to deploy the observability component (opentelemetry-collector-k8s)"
  type        = bool
  default     = false
}

variable "dashboards_offer" {
  description = "URL of the grafana_dashboard interface offer from the COS stack (required when enable_observability is true)"
  type        = string
  default     = null
}

variable "logging_offer" {
  description = "URL of the loki_push_api interface offer from the COS stack (required when enable_observability is true)"
  type        = string
  default     = null
}

variable "metrics_offer" {
  description = "URL of the prometheus_remote_write interface offer from the COS stack (required when enable_observability is true)"
  type        = string
  default     = null
}

variable "opentelemetry_collector_k8s_revision" {
  description = "Revision of the opentelemetry-collector-k8s application"
  type        = number
  default     = null
}

variable "opentelemetry_collector_k8s_config" {
  description = "Configuration for the opentelemetry-collector-k8s application"
  type        = map(string)
  default     = {}
}

# PostgreSQL

variable "postgresql_revision" {
  description = "Revision of the postgresql application"
  type        = number
  default     = null
}

variable "postgresql_config" {
  description = "Configuration for the postgresql application"
  type        = map(string)
  default     = {}
}

variable "postgresql_storage_size" {
  description = "PostgreSQL database storage size"
  type        = string
  default     = "10G"
}

variable "http_proxy" {
  description = "Value of the http_proxy environment variable"
  type        = string
  default     = ""
}

variable "https_proxy" {
  description = "Value of the https_proxy environment variable"
  type        = string
  default     = ""
}

variable "no_proxy" {
  description = "Value of the no_proxy environment variable"
  type        = string
  default     = ""
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "cos_model_uuid" {
  description = "UUID of the cos model hosting COS Lite."
  value       = local.cos_model_uuid
}

output "istio_system_model_uuid" {
  description = "UUID of the istio-system model hosting the Istio control plane."
  value       = module.mlflow_ambient_iam.istio_system_model_uuid
}

output "istio_ingress_config_offer_url" {
  description = "Cross-model offer URL of istio-k8s:istio-ingress-config consumed by the mlflow gateways."
  value       = module.mlflow_ambient_iam.istio_ingress_config_offer_url
}

output "iam_model_uuid" {
  description = "UUID of the iam model hosting the Canonical Identity Platform."
  value       = module.mlflow_ambient_iam.iam_model_uuid
}

output "oauth_offer_url" {
  description = "Cross-model offer URL of hydra:oauth consumed by the mlflow IAM auth charms."
  value       = module.mlflow_ambient_iam.oauth_offer_url
}

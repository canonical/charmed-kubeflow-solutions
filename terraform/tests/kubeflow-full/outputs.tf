# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "istio_system_model_uuid" {
  description = "UUID of the istio-system model hosting the Istio control plane."
  value       = local.istio_system_model_uuid
}

output "istio_ingress_config_offer_url" {
  description = "Cross-model offer URL of istio-k8s:istio-ingress-config consumed by the kubeflow gateways."
  value       = juju_offer.istio_ingress_config.url
}

output "iam_model_uuid" {
  description = "UUID of the iam model hosting the Canonical Identity Platform."
  value       = module.iam.model_uuid
}

output "oauth_offer_url" {
  description = "Cross-model offer URL of hydra:oauth consumed by the kubeflow IAM auth charms."
  value       = module.iam.oauth_offer_url
}

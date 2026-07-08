# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "model_uuid" {
  description = "UUID of the iam model."
  value       = local.model_uuid
}

output "iam_core_model_uuid" {
  description = "UUID of the iam-core model."
  value       = local.iam_core_model_uuid
}

output "model_name" {
  description = "Name of the iam model."
  value       = var.create_model ? juju_model.iam[0].name : null
}

output "iam_core_model_name" {
  description = "Name of the iam-core model."
  value       = var.create_model ? juju_model.iam_core[0].name : null
}

output "oauth_offer_url" {
  description = "Hydra OAuth offer URL, consumed cross-model by oauth2-proxy and request-authentication-configurator in the kubeflow model."
  value       = module.iam_bundle.oauth_offer_url
}

output "send_ca_cert_offer_url" {
  description = "self-signed-certificates send-ca-cert offer URL (iam-core model), consumed cross-model (e.g. by istio-k8s:jwks-ca-cert and oauth2-proxy:receive-ca-cert)."
  value       = juju_offer.send_ca_cert.url
}

# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "model_uuid" {
  description = "UUID of the iam model."
  value       = local.model_uuid
}

output "model_name" {
  description = "Name of the iam model."
  value       = var.create_model ? juju_model.iam[0].name : null
}

output "oauth_offer_url" {
  description = "Hydra OAuth offer URL, consumed cross-model by oauth2-proxy and request-authentication-configurator in the kubeflow model."
  value       = module.iam_bundle.oauth_offer_url
}

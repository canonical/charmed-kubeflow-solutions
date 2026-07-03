# Vendored: iam-bundle-integration

This is a **vendored copy** of the root module of
[`canonical/iam-bundle-integration`](https://github.com/canonical/iam-bundle-integration)
at tag **`v1.1.1`**.

## Why it is vendored

Upstream `providers.tf` pins the Juju provider to `~> 1.0.0` (i.e. `1.0.x`
only). The `charmed-kubeflow-solutions` refactoring requires juju provider
`>= 1.1.1` (it relies on `juju_integration` behaviour fixed after `1.0.x`).
Those two constraints cannot be satisfied by a single provider version, and
Terraform does not allow a parent module to relax a child module's provider
constraints.

To let the Identity Platform compose in the **same Terraform root** as the rest
of the deployment, this copy applies a single change:

- `providers.tf`: `version = "~> 1.0.0"` → `version = "~> 1.0"`

The module's own code (and its hydra / kratos / login-ui / idp submodules, which
already allow `juju >= 1.0.0` and are still fetched from upstream over git) is
otherwise unchanged and is compatible with juju provider `1.x`.

## Re-syncing with upstream

When bumping the Identity Platform version, re-copy the root `*.tf` files from
the desired upstream tag and re-apply the one-line `providers.tf` change above.
Upstream root files vendored here: `applications.tf`, `cos.tf`,
`integrations.tf`, `main.tf`, `outputs.tf`, `providers.tf`, `variables.tf`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | ~> 1.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_juju"></a> [juju](#provider\_juju) | ~> 1.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_hydra"></a> [hydra](#module\_hydra) | github.com/canonical/hydra-operator//terraform | v2.0.0 |
| <a name="module_kratos"></a> [kratos](#module\_kratos) | github.com/canonical/kratos-operator//terraform | v2.0.0 |
| <a name="module_kratos_external_idp_integrator"></a> [kratos\_external\_idp\_integrator](#module\_kratos\_external\_idp\_integrator) | github.com/canonical/kratos-external-idp-integrator//terraform | 80ce05e |
| <a name="module_login_ui"></a> [login\_ui](#module\_login\_ui) | github.com/canonical/identity-platform-login-ui-operator//terraform | v2.1.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_integration.grafana_dashboard_hydra](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.grafana_dashboard_kratos](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.grafana_dashboard_login_ui](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.hydra_database](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.hydra_login_ui_ui_info](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.hydra_public_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kratos_database](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kratos_external_idp](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kratos_hydra_info](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kratos_login_ui_info](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kratos_login_ui_ui_info](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kratos_public_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.logging_hydra](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.logging_kratos](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.logging_login_ui](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.login_ui_hydra_info](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.login_ui_public_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.metrics_hydra](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.metrics_kratos](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.metrics_login_ui](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tracing_hydra](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tracing_kratos](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.tracing_login_ui](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_offer.kratos_info_offer](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |
| [juju_model.this](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/model) | data source |
| [juju_offer.database](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |
| [juju_offer.grafana_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |
| [juju_offer.logging](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |
| [juju_offer.metrics](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |
| [juju_offer.tracing](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |
| [juju_offer.traefik_route](https://registry.terraform.io/providers/juju/juju/latest/docs/data-sources/offer) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_enable_kratos_external_idp_integrator"></a> [enable\_kratos\_external\_idp\_integrator](#input\_enable\_kratos\_external\_idp\_integrator) | Whether to deploy Kratos External IdP Integrator | `bool` | `false` | no |
| <a name="input_grafana_dashboard_offer_url"></a> [grafana\_dashboard\_offer\_url](#input\_grafana\_dashboard\_offer\_url) | Grafana Dashboard Offer URL | `string` | `null` | no |
| <a name="input_hydra"></a> [hydra](#input\_hydra) | The configurations of the Hydra application. | <pre>object({<br/>    name        = optional(string, "hydra")<br/>    units       = optional(number, 1)<br/>    channel     = optional(string, "latest/edge")<br/>    base        = optional(string, "ubuntu@22.04")<br/>    trust       = optional(string, true)<br/>    config      = optional(map(string), {})<br/>    constraints = optional(string, "")<br/>    revision    = optional(number, null)<br/>  })</pre> | `{}` | no |
| <a name="input_kratos"></a> [kratos](#input\_kratos) | The configurations of the Kratos application. | <pre>object({<br/>    name        = optional(string, "kratos")<br/>    units       = optional(number, 1)<br/>    channel     = optional(string, "latest/edge")<br/>    base        = optional(string, "ubuntu@22.04")<br/>    trust       = optional(string, true)<br/>    config      = optional(map(string), {})<br/>    constraints = optional(string, "")<br/>    revision    = optional(number, null)<br/>  })</pre> | `{}` | no |
| <a name="input_kratos_external_idp_integrator"></a> [kratos\_external\_idp\_integrator](#input\_kratos\_external\_idp\_integrator) | The configurations of the Kratos application. | <pre>object({<br/>    name    = optional(string, "kratos-external-idp-integrator")<br/>    units   = optional(number, 1)<br/>    channel = optional(string, "latest/edge")<br/>    base    = optional(string, "ubuntu@22.04")<br/>    trust   = optional(string, true)<br/>    config = optional(object({<br/>      client_id : string<br/>      client_secret : string<br/>      issuer_url : optional(string, "")<br/>      provider : string<br/>      provider_id : string<br/>      scope : optional(string, "profile email address phone")<br/>      microsoft_tenant_id : optional(string, "")<br/>      apple_team_id : optional(string, "")<br/>      apple_private_key_id : optional(string, "")<br/>      apple_private_key : optional(string, "")<br/>      })<br/>    )<br/><br/>    constraints = optional(string, "")<br/>    revision    = optional(number, null)<br/>  })</pre> | `{}` | no |
| <a name="input_logging_offer_url"></a> [logging\_offer\_url](#input\_logging\_offer\_url) | Logging Offer URL | `string` | `null` | no |
| <a name="input_login_ui"></a> [login\_ui](#input\_login\_ui) | The configurations of the Identity Platform Login UI application. | <pre>object({<br/>    name        = optional(string, "login-ui")<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    config      = optional(map(string), {})<br/>    channel     = optional(string, "latest/edge")<br/>    base        = optional(string, "ubuntu@22.04")<br/>    constraints = optional(string, "")<br/>    revision    = optional(number, null)<br/>  })</pre> | `{}` | no |
| <a name="input_metrics_offer_url"></a> [metrics\_offer\_url](#input\_metrics\_offer\_url) | Metrics Offer URL | `string` | `null` | no |
| <a name="input_model"></a> [model](#input\_model) | The uuid of the Juju model to deploy to. | `string` | n/a | yes |
| <a name="input_postgresql_offer_url"></a> [postgresql\_offer\_url](#input\_postgresql\_offer\_url) | PostgreSQL Offer URL | `string` | `"admin/core.postgresql"` | no |
| <a name="input_tracing_offer_url"></a> [tracing\_offer\_url](#input\_tracing\_offer\_url) | Tracing Offer URL | `string` | `null` | no |
| <a name="input_traefik_route_offer_url"></a> [traefik\_route\_offer\_url](#input\_traefik\_route\_offer\_url) | Traefik Route Offer URL | `string` | `"admin/core.traefik-route"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_oauth_offer_url"></a> [oauth\_offer\_url](#output\_oauth\_offer\_url) | The Hydra OAuth Juju offer resource. |
<!-- END_TF_DOCS -->
# iam product

Wrapper product that deploys the **Canonical Identity Platform** (Hydra, Kratos,
Identity Platform Login UI) into a dedicated `iam` model, together with its
in-model dependencies (`postgresql-k8s`, `traefik-k8s`,
`self-signed-certificates`).

It reuses the upstream
[`canonical/iam-bundle-integration`](https://github.com/canonical/iam-bundle-integration)
Terraform module (pinned to `v1.1.1`).

Because that module consumes its dependencies through offer URLs (it reads the
model via `data.juju_model.this`), this product creates **same-model offers**
for `postgresql:database` and `traefik:traefik-route` and feeds their URLs into
the module.

The product exposes `oauth_offer_url` (Hydra `oauth`), consumed cross-model by
`oauth2-proxy` and `request-authentication-configurator` in the `kubeflow`
model.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.1.1 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.1.1 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_iam_bundle"></a> [iam\_bundle](#module\_iam\_bundle) | ../../vendor/iam-bundle-integration | n/a |
| <a name="module_postgresql_k8s"></a> [postgresql\_k8s](#module\_postgresql\_k8s) | git::https://github.com/canonical/postgresql-k8s-operator//terraform | b7822d93f8d5d0d94ca3da36ea9f5b13f3e58d43 |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_application.self_signed_certificates](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.traefik](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.kratos_receive_ca_cert](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.login_ui_receive_ca_cert](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.traefik_certificates](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_model.iam](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |
| [juju_model.iam_core](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |
| [juju_offer.postgresql](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |
| [juju_offer.send_ca_cert](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |
| [juju_offer.traefik_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_create_model"></a> [create\_model](#input\_create\_model) | Whether to create the iam model. Set to false to deploy into an existing model referenced by model\_uuid. | `bool` | `true` | no |
| <a name="input_enable_kratos_external_idp_integrator"></a> [enable\_kratos\_external\_idp\_integrator](#input\_enable\_kratos\_external\_idp\_integrator) | Whether to deploy the Kratos External IdP Integrator (Google / Entra / etc.). | `bool` | `false` | no |
| <a name="input_hydra"></a> [hydra](#input\_hydra) | Configuration for the Hydra application (passed through to the iam-bundle module). | `any` | `{}` | no |
| <a name="input_hydra_revision"></a> [hydra\_revision](#input\_hydra\_revision) | Revision for the Hydra application. Overrides the revision in var.hydra when set. | `number` | `null` | no |
| <a name="input_iam_core_model_name"></a> [iam\_core\_model\_name](#input\_iam\_core\_model\_name) | Name of the iam-core model (postgresql-k8s / traefik-k8s / self-signed-certificates) to create when create\_model is true. | `string` | `"iam-core"` | no |
| <a name="input_iam_core_model_uuid"></a> [iam\_core\_model\_uuid](#input\_iam\_core\_model\_uuid) | UUID of an existing iam-core model when create\_model is false. | `string` | `null` | no |
| <a name="input_kratos"></a> [kratos](#input\_kratos) | Configuration for the Kratos application (passed through to the iam-bundle module). | `any` | `{}` | no |
| <a name="input_kratos_external_idp_integrator"></a> [kratos\_external\_idp\_integrator](#input\_kratos\_external\_idp\_integrator) | Configuration for the Kratos External IdP Integrator application (passed through to the iam-bundle module). | `any` | `{}` | no |
| <a name="input_kratos_revision"></a> [kratos\_revision](#input\_kratos\_revision) | Revision for the Kratos application. Overrides the revision in var.kratos when set. | `number` | `null` | no |
| <a name="input_login_ui"></a> [login\_ui](#input\_login\_ui) | Configuration for the Identity Platform Login UI application (passed through to the iam-bundle module). | `any` | `{}` | no |
| <a name="input_login_ui_revision"></a> [login\_ui\_revision](#input\_login\_ui\_revision) | Revision for the Identity Platform Login UI application. Overrides the revision in var.login\_ui when set. | `number` | `null` | no |
| <a name="input_model_name"></a> [model\_name](#input\_model\_name) | Name of the iam model to create when create\_model is true. | `string` | `"iam"` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of an existing model to deploy into when create\_model is false. | `string` | `null` | no |
| <a name="input_postgresql_k8s_channel"></a> [postgresql\_k8s\_channel](#input\_postgresql\_k8s\_channel) | Channel for the postgresql-k8s dependency. | `string` | `"14/stable"` | no |
| <a name="input_postgresql_k8s_config"></a> [postgresql\_k8s\_config](#input\_postgresql\_k8s\_config) | Extra config for the postgresql-k8s dependency. | `map(string)` | `{}` | no |
| <a name="input_postgresql_k8s_revision"></a> [postgresql\_k8s\_revision](#input\_postgresql\_k8s\_revision) | Revision for the postgresql-k8s dependency. | `number` | `null` | no |
| <a name="input_self_signed_certificates_channel"></a> [self\_signed\_certificates\_channel](#input\_self\_signed\_certificates\_channel) | Channel for the self-signed-certificates dependency. | `string` | `"latest/stable"` | no |
| <a name="input_self_signed_certificates_config"></a> [self\_signed\_certificates\_config](#input\_self\_signed\_certificates\_config) | Config for the self-signed-certificates dependency. | `map(string)` | `{}` | no |
| <a name="input_self_signed_certificates_revision"></a> [self\_signed\_certificates\_revision](#input\_self\_signed\_certificates\_revision) | Revision for the self-signed-certificates dependency. | `number` | `null` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Storage size for the postgresql-k8s dependency. | `string` | `"10GB"` | no |
| <a name="input_traefik_channel"></a> [traefik\_channel](#input\_traefik\_channel) | Channel for the traefik-k8s dependency. | `string` | `"latest/stable"` | no |
| <a name="input_traefik_config"></a> [traefik\_config](#input\_traefik\_config) | Config for the traefik-k8s dependency (e.g. external\_hostname). | `map(string)` | `{}` | no |
| <a name="input_traefik_revision"></a> [traefik\_revision](#input\_traefik\_revision) | Revision for the traefik-k8s dependency. | `number` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_iam_core_model_name"></a> [iam\_core\_model\_name](#output\_iam\_core\_model\_name) | Name of the iam-core model. |
| <a name="output_iam_core_model_uuid"></a> [iam\_core\_model\_uuid](#output\_iam\_core\_model\_uuid) | UUID of the iam-core model. |
| <a name="output_model_name"></a> [model\_name](#output\_model\_name) | Name of the iam model. |
| <a name="output_model_uuid"></a> [model\_uuid](#output\_model\_uuid) | UUID of the iam model. |
| <a name="output_oauth_offer_url"></a> [oauth\_offer\_url](#output\_oauth\_offer\_url) | Hydra OAuth offer URL, consumed cross-model by oauth2-proxy and request-authentication-configurator in the kubeflow model. |
| <a name="output_send_ca_cert_offer_url"></a> [send\_ca\_cert\_offer\_url](#output\_send\_ca\_cert\_offer\_url) | self-signed-certificates send-ca-cert offer URL (iam-core model), consumed cross-model (e.g. by istio-k8s:jwks-ca-cert and oauth2-proxy:receive-ca-cert). |
<!-- END_TF_DOCS -->

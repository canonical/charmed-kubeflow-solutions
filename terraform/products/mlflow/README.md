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
| <a name="module_ambient_iam"></a> [ambient\_iam](#module\_ambient\_iam) | ../../components/istio-ambient | n/a |
| <a name="module_data_integrator_integrations"></a> [data\_integrator\_integrations](#module\_data\_integrator\_integrations) | ../../components/data-integrator | n/a |
| <a name="module_mlflow"></a> [mlflow](#module\_mlflow) | ../../components/mlflow | n/a |
| <a name="module_oauth2_proxy"></a> [oauth2\_proxy](#module\_oauth2\_proxy) | ../../charms/oauth2-proxy-k8s | n/a |
| <a name="module_observability"></a> [observability](#module\_observability) | ../../components/observability | n/a |
| <a name="module_postgresql"></a> [postgresql](#module\_postgresql) | git::https://github.com/canonical/postgresql-k8s-operator//terraform | b7822d93f8d5d0d94ca3da36ea9f5b13f3e58d43 |
| <a name="module_request_authentication_configurator"></a> [request\_authentication\_configurator](#module\_request\_authentication\_configurator) | ../../charms/request-authentication-configurator | n/a |
| <a name="module_s3_global"></a> [s3\_global](#module\_s3\_global) | ../../charms/s3-integrator | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_access_secret.s3_secret_access_global](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/access_secret) | resource |
| [juju_application.self_signed_certificates](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.istio_ingress_m2m_certificates](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.istio_ingress_ui_certificates](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.mlflow_server_m2m_istio_ingress_route](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.oauth2_proxy_ui_forward_auth](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.oauth2_proxy_ui_ingress](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.request_auth_m2m](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.request_auth_ui](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_model.mlflow](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |
| [juju_secret.s3_secret_global](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_create_model"></a> [create\_model](#input\_create\_model) | Create a Juju model named mlflow for this product deployment | `bool` | `true` | no |
| <a name="input_dashboards_offer"></a> [dashboards\_offer](#input\_dashboards\_offer) | URL of the grafana\_dashboard interface offer from the COS stack (required when enable\_observability is true) | `string` | `null` | no |
| <a name="input_enable_observability"></a> [enable\_observability](#input\_enable\_observability) | Whether to deploy the observability component (opentelemetry-collector-k8s) | `bool` | `false` | no |
| <a name="input_http_proxy"></a> [http\_proxy](#input\_http\_proxy) | Value of the http\_proxy environment variable | `string` | `""` | no |
| <a name="input_https_proxy"></a> [https\_proxy](#input\_https\_proxy) | Value of the https\_proxy environment variable | `string` | `""` | no |
| <a name="input_istio_beacon_k8s_config"></a> [istio\_beacon\_k8s\_config](#input\_istio\_beacon\_k8s\_config) | Configuration for istio-beacon-k8s application | `map(string)` | `{}` | no |
| <a name="input_istio_beacon_k8s_revision"></a> [istio\_beacon\_k8s\_revision](#input\_istio\_beacon\_k8s\_revision) | Revision of the istio-beacon-k8s application | `number` | `null` | no |
| <a name="input_istio_ingress_config_offer_url"></a> [istio\_ingress\_config\_offer\_url](#input\_istio\_ingress\_config\_offer\_url) | Cross-model offer URL of istio-k8s:istio-ingress-config from the<br/>istio-system model. The UI ambient gateway consumes this offer. Required when<br/>service\_mesh\_type is 'ambient'. | `string` | `null` | no |
| <a name="input_istio_ingress_k8s_config"></a> [istio\_ingress\_k8s\_config](#input\_istio\_ingress\_k8s\_config) | Configuration for istio-ingress-k8s application | `map(string)` | `{}` | no |
| <a name="input_istio_ingress_k8s_m2m_config"></a> [istio\_ingress\_k8s\_m2m\_config](#input\_istio\_ingress\_k8s\_m2m\_config) | Extra configuration for the M2M istio-ingress-k8s gateway (merged over istio\_ingress\_k8s\_config) | `map(string)` | `{}` | no |
| <a name="input_istio_ingress_k8s_revision"></a> [istio\_ingress\_k8s\_revision](#input\_istio\_ingress\_k8s\_revision) | Revision of the istio-ingress-k8s application | `number` | `null` | no |
| <a name="input_istio_ingress_k8s_ui_config"></a> [istio\_ingress\_k8s\_ui\_config](#input\_istio\_ingress\_k8s\_ui\_config) | Extra configuration for the UI istio-ingress-k8s gateway (merged over istio\_ingress\_k8s\_config) | `map(string)` | `{}` | no |
| <a name="input_logging_offer"></a> [logging\_offer](#input\_logging\_offer) | URL of the loki\_push\_api interface offer from the COS stack (required when enable\_observability is true) | `string` | `null` | no |
| <a name="input_metrics_offer"></a> [metrics\_offer](#input\_metrics\_offer) | URL of the prometheus\_remote\_write interface offer from the COS stack (required when enable\_observability is true) | `string` | `null` | no |
| <a name="input_mlflow_server_config"></a> [mlflow\_server\_config](#input\_mlflow\_server\_config) | Configuration for mlflow-server application | `map(string)` | <pre>{<br/>  "identity_header_name": "mlflow-userid",<br/>  "serve_artifacts": true<br/>}</pre> | no |
| <a name="input_mlflow_server_revision"></a> [mlflow\_server\_revision](#input\_mlflow\_server\_revision) | Revision of the mlflow-server application | `number` | `1579` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of an existing Juju model (required when create\_model is false) | `string` | `null` | no |
| <a name="input_no_proxy"></a> [no\_proxy](#input\_no\_proxy) | Value of the no\_proxy environment variable | `string` | `""` | no |
| <a name="input_oauth2_proxy_config"></a> [oauth2\_proxy\_config](#input\_oauth2\_proxy\_config) | Configuration for the oauth2-proxy-k8s application | `map(string)` | `{}` | no |
| <a name="input_oauth2_proxy_revision"></a> [oauth2\_proxy\_revision](#input\_oauth2\_proxy\_revision) | Revision of the oauth2-proxy-k8s application | `number` | `null` | no |
| <a name="input_oauth_offer_url"></a> [oauth\_offer\_url](#input\_oauth\_offer\_url) | Cross-model offer URL of hydra:oauth from the iam model. Consumed by<br/>oauth2-proxy and request-authentication-configurator. Required when<br/>service\_mesh\_type is 'ambient'. | `string` | `null` | no |
| <a name="input_opentelemetry_collector_k8s_config"></a> [opentelemetry\_collector\_k8s\_config](#input\_opentelemetry\_collector\_k8s\_config) | Configuration for the opentelemetry-collector-k8s application | `map(string)` | `{}` | no |
| <a name="input_opentelemetry_collector_k8s_revision"></a> [opentelemetry\_collector\_k8s\_revision](#input\_opentelemetry\_collector\_k8s\_revision) | Revision of the opentelemetry-collector-k8s application | `number` | `null` | no |
| <a name="input_postgresql_config"></a> [postgresql\_config](#input\_postgresql\_config) | Configuration for the postgresql application | `map(string)` | `{}` | no |
| <a name="input_postgresql_revision"></a> [postgresql\_revision](#input\_postgresql\_revision) | Revision of the postgresql application | `number` | `null` | no |
| <a name="input_postgresql_storage_size"></a> [postgresql\_storage\_size](#input\_postgresql\_storage\_size) | PostgreSQL database storage size | `string` | `"10G"` | no |
| <a name="input_release"></a> [release](#input\_release) | MLflow release to deploy. Use 'latest' for latest tracks or '1.11' for pinned 1.11 tracks. | `string` | `"latest"` | no |
| <a name="input_request_authentication_configurator_config"></a> [request\_authentication\_configurator\_config](#input\_request\_authentication\_configurator\_config) | Configuration for the request-authentication-configurator application | `map(string)` | `{}` | no |
| <a name="input_request_authentication_configurator_revision"></a> [request\_authentication\_configurator\_revision](#input\_request\_authentication\_configurator\_revision) | Revision of the request-authentication-configurator application | `number` | `null` | no |
| <a name="input_risk"></a> [risk](#input\_risk) | Value for the risk to be used | `string` | `"edge"` | no |
| <a name="input_s3_access_key_global"></a> [s3\_access\_key\_global](#input\_s3\_access\_key\_global) | S3 access key for the shared object storage integration | `string` | `""` | no |
| <a name="input_s3_bucket_global"></a> [s3\_bucket\_global](#input\_s3\_bucket\_global) | S3 bucket for the shared object storage integration | `string` | `""` | no |
| <a name="input_s3_config_global"></a> [s3\_config\_global](#input\_s3\_config\_global) | Configuration for the shared s3-integrator application | `map(string)` | `{}` | no |
| <a name="input_s3_endpoint_global"></a> [s3\_endpoint\_global](#input\_s3\_endpoint\_global) | S3 endpoint for the shared object storage integration | `string` | `""` | no |
| <a name="input_s3_revision_global"></a> [s3\_revision\_global](#input\_s3\_revision\_global) | Revision of the shared s3-integrator application | `number` | `null` | no |
| <a name="input_s3_secret_key_global"></a> [s3\_secret\_key\_global](#input\_s3\_secret\_key\_global) | S3 secret key for the shared object storage integration | `string` | `""` | no |
| <a name="input_s3_tls_ca_chain_global"></a> [s3\_tls\_ca\_chain\_global](#input\_s3\_tls\_ca\_chain\_global) | PEM-encoded CA chain used for HTTPS validation against the S3 endpoint. When set, it is base64-encoded and passed to the s3-integrator 'tls-ca-chain' config option. Leave empty to omit. | `string` | `""` | no |
| <a name="input_self_signed_certificates_channel"></a> [self\_signed\_certificates\_channel](#input\_self\_signed\_certificates\_channel) | Channel for the self-signed-certificates charm serving the ambient gateways. | `string` | `"1/stable"` | no |
| <a name="input_self_signed_certificates_config"></a> [self\_signed\_certificates\_config](#input\_self\_signed\_certificates\_config) | Configuration for the self-signed-certificates application. | `map(string)` | `{}` | no |
| <a name="input_self_signed_certificates_revision"></a> [self\_signed\_certificates\_revision](#input\_self\_signed\_certificates\_revision) | Revision of the self-signed-certificates application. | `number` | `null` | no |
| <a name="input_send_ca_cert_offer_url"></a> [send\_ca\_cert\_offer\_url](#input\_send\_ca\_cert\_offer\_url) | Cross-model offer URL of self-signed-certificates:send-ca-cert from the<br/>iam-core model. Consumed by oauth2-proxy on receive-ca-cert to trust the<br/>self-signed CA fronting the Identity Platform. Required when<br/>service\_mesh\_type is 'ambient'. | `string` | `null` | no |
| <a name="input_user_grants_across_workspaces"></a> [user\_grants\_across\_workspaces](#input\_user\_grants\_across\_workspaces) | Grants for all MLflow users across MLflow workspaces in terms of data-integrator instances,<br/>with each item of a list representing grants across all workspaces for a given user, and<br/>with each key representing the instance's name and the corresponding value the respective<br/>instance's relevant configurations for MLflow | <pre>map(object({<br/>    entity_name        = string<br/>    entity_permissions = string<br/>  }))</pre> | `{}` | no |
<!-- END_TF_DOCS -->

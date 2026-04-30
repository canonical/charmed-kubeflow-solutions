# Feast Component

This Terraform module deploys the [Feast](https://feast.dev/) feature store component for Charmed Kubeflow.

## Applications

| Application | Description |
|-------------|-------------|
| `feast-integrator` | Manages Feast configuration and integrates with storage backends |
| `feast-ui` | Feast web UI for managing and browsing features |

## Integrations

### Required (from other components)

| Variable | Endpoint | Provider |
|----------|----------|----------|
| `offline_store` | `offline-store` | `postgresql-k8s:database` |
| `online_store` | `online-store` | `postgresql-k8s:database` |
| `registry` | `registry` | `postgresql-k8s:database` |
| `secrets` | `secrets` | `resource-dispatcher:secrets` |
| `pod_defaults` | `pod-defaults` | `resource-dispatcher:pod-defaults` |
| `dashboard_links` | `dashboard-links` | `kubeflow-dashboard:links` |
| `ingress` | `ingress` | `istio-pilot:ingress` (sidecar) |
| `istio_ingress_route` | `istio-ingress-route` | `istio-ingress-k8s:istio-ingress-route` (ambient) |
| `service_mesh` | `service-mesh` | `istio-beacon-k8s:service-mesh` (ambient) |

## Usage

```hcl
module "feast" {
  source = "../../components/feast"

  model_uuid = var.model_uuid

  offline_store = {
    kind     = "endpoint"
    name     = module.postgresql_k8s_feast_offline[0].application_name
    endpoint = module.postgresql_k8s_feast_offline[0].provides.database
  }

  online_store = {
    kind     = "endpoint"
    name     = module.postgresql_k8s_feast_online[0].application_name
    endpoint = module.postgresql_k8s_feast_online[0].provides.database
  }

  registry = {
    kind     = "endpoint"
    name     = module.postgresql_k8s_feast_registry[0].application_name
    endpoint = module.postgresql_k8s_feast_registry[0].provides.database
  }

  secrets = {
    kind     = "endpoint"
    name     = module.resource_dispatcher[0].provides.secrets.name
    endpoint = module.resource_dispatcher[0].provides.secrets.endpoint
  }

  pod_defaults = {
    kind     = "endpoint"
    name     = module.resource_dispatcher[0].provides.pod_defaults.name
    endpoint = module.resource_dispatcher[0].provides.pod_defaults.endpoint
  }

  dashboard_links = {
    kind     = "endpoint"
    name     = module.core.provides.kubeflow_dashboard_links.name
    endpoint = module.core.provides.kubeflow_dashboard_links.endpoint
  }

  feast_integrator = {
    channel = "0.49/stable"
  }

  feast_ui = {
    channel = "0.49/stable"
  }
}
```

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

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [juju_application.feast_integrator](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.feast_ui](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.feast_integrator_offline_store](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.feast_integrator_online_store](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.feast_integrator_pod_defaults](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.feast_integrator_registry](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.feast_integrator_secrets](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.feast_ui_dashboard_links](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.feast_ui_feast_integrator_feast_configuration](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.feast_ui_ingress](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_dashboard_links"></a> [dashboard\_links](#input\_dashboard\_links) | Kubeflow Dashboard links provider for feast-ui from kubeflow-dashboard:links (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_feast_integrator"></a> [feast\_integrator](#input\_feast\_integrator) | Configuration for feast-integrator application | <pre>object({<br/>    app_name    = optional(string, "feast-integrator")<br/>    channel     = optional(string, "0.49/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_feast_ui"></a> [feast\_ui](#input\_feast\_ui) | Configuration for feast-ui application | <pre>object({<br/>    app_name    = optional(string, "feast-ui")<br/>    channel     = optional(string, "0.49/stable")<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>    trust       = optional(bool, true)<br/>    constraints = optional(string, "arch=amd64")<br/>    config      = optional(map(string), {})<br/>    resources   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress provider for feast-ui from istio-pilot:ingress (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the Juju model where Feast is deployed | `string` | n/a | yes |
| <a name="input_offline_store"></a> [offline\_store](#input\_offline\_store) | PostgreSQL database provider for feast-integrator offline store from postgresql-k8s:database (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_online_store"></a> [online\_store](#input\_online\_store) | PostgreSQL database provider for feast-integrator online store from postgresql-k8s:database (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_pod_defaults"></a> [pod\_defaults](#input\_pod\_defaults) | Pod defaults provider for feast-integrator from resource-dispatcher:pod-defaults (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_registry"></a> [registry](#input\_registry) | PostgreSQL database provider for feast-integrator registry from postgresql-k8s:database (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secrets provider for feast-integrator from resource-dispatcher:secrets (supports same-model endpoint or cross-model offer) | <pre>object({<br/>    kind     = string<br/>    name     = optional(string, null)<br/>    endpoint = optional(string, null)<br/>    url      = optional(string, null)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of the deployed Feast applications |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of endpoints provided by this component to other components (outbound relations) |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of endpoints required by this component from other components (inbound relations) |
<!-- END_TF_DOCS -->
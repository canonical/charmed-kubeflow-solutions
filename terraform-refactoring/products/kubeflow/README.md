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
| <a name="module_ambient"></a> [ambient](#module\_ambient) | git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/istio-ambient | feat/terraform-refactor |
| <a name="module_auth"></a> [auth](#module\_auth) | git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/auth | feat/terraform-refactor |
| <a name="module_core"></a> [core](#module\_core) | git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/core | feat/terraform-refactor |
| <a name="module_istio"></a> [istio](#module\_istio) | git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/istio-sidecar | feat/terraform-refactor |
| <a name="module_katib"></a> [katib](#module\_katib) | git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/katib | feat/terraform-refactor |
| <a name="module_kfp"></a> [kfp](#module\_kfp) | git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/components/kfp | feat/terraform-refactor |
| <a name="module_kserve"></a> [kserve](#module\_kserve) | ../../components/kserve | n/a |
| <a name="module_minio"></a> [minio](#module\_minio) | git::https://github.com/canonical/charmed-kubeflow-solutions//terraform-refactoring/charms/minio | feat/terraform-refactor |
| <a name="module_mlflow"></a> [mlflow](#module\_mlflow) | ../../components/mlflow | n/a |
| <a name="module_mysql"></a> [mysql](#module\_mysql) | git::https://github.com/canonical/mysql-k8s-operator//terraform | 58072079edc97bace08b6ff9c8f380b94867ebd4 |
| <a name="module_resource_dispatcher"></a> [resource\_dispatcher](#module\_resource\_dispatcher) | ../../charms/resource-dispatcher | n/a |
| <a name="module_tensorboard"></a> [tensorboard](#module\_tensorboard) | ../../components/tensorboard | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_integration.kserve_controller_object_storage](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kserve_controller_pod_defaults](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.kserve_controller_secrets](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.minio_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.oidc_gatekeeper_istio_ingress_k8s_forward_auth](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.resource_dispatcher_service_mesh](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_model.kubeflow](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_argo_controller_config"></a> [argo\_controller\_config](#input\_argo\_controller\_config) | Configuration for argo-controller application | `map(string)` | `{}` | no |
| <a name="input_argo_controller_revision"></a> [argo\_controller\_revision](#input\_argo\_controller\_revision) | Revision of the argo-controller application | `number` | `null` | no |
| <a name="input_create_model"></a> [create\_model](#input\_create\_model) | Create a Juju model named kubeflow for this product deployment | `bool` | `true` | no |
| <a name="input_dex_auth_config"></a> [dex\_auth\_config](#input\_dex\_auth\_config) | Configuration for dex-auth application | `map(string)` | `{}` | no |
| <a name="input_dex_auth_revision"></a> [dex\_auth\_revision](#input\_dex\_auth\_revision) | Revision of the dex-auth application | `number` | `null` | no |
| <a name="input_enable_katib"></a> [enable\_katib](#input\_enable\_katib) | Whether to deploy the Katib component | `bool` | `true` | no |
| <a name="input_enable_kfp"></a> [enable\_kfp](#input\_enable\_kfp) | Whether to deploy the KFP component | `bool` | `true` | no |
| <a name="input_enable_kserve"></a> [enable\_kserve](#input\_enable\_kserve) | Whether to deploy the KServe component | `bool` | `true` | no |
| <a name="input_enable_mlflow"></a> [enable\_mlflow](#input\_enable\_mlflow) | Whether to deploy the MLflow component (mlflow-server) and resource-dispatcher | `bool` | `false` | no |
| <a name="input_enable_tensorboard"></a> [enable\_tensorboard](#input\_enable\_tensorboard) | Whether to deploy the Tensorboard component | `bool` | `true` | no |
| <a name="input_envoy_config"></a> [envoy\_config](#input\_envoy\_config) | Configuration for envoy application | `map(string)` | `{}` | no |
| <a name="input_envoy_revision"></a> [envoy\_revision](#input\_envoy\_revision) | Revision of the envoy application | `number` | `null` | no |
| <a name="input_istio_beacon_k8s_config"></a> [istio\_beacon\_k8s\_config](#input\_istio\_beacon\_k8s\_config) | Configuration for istio-beacon-k8s application | `map(string)` | `{}` | no |
| <a name="input_istio_beacon_k8s_revision"></a> [istio\_beacon\_k8s\_revision](#input\_istio\_beacon\_k8s\_revision) | Revision of the istio-beacon-k8s application | `number` | `null` | no |
| <a name="input_istio_ingress_k8s_config"></a> [istio\_ingress\_k8s\_config](#input\_istio\_ingress\_k8s\_config) | Configuration for istio-ingress-k8s application | `map(string)` | `{}` | no |
| <a name="input_istio_ingress_k8s_revision"></a> [istio\_ingress\_k8s\_revision](#input\_istio\_ingress\_k8s\_revision) | Revision of the istio-ingress-k8s application | `number` | `null` | no |
| <a name="input_istio_ingressgateway_config"></a> [istio\_ingressgateway\_config](#input\_istio\_ingressgateway\_config) | Configuration for istio-ingressgateway application | `map(string)` | <pre>{<br/>  "kind": "ingress"<br/>}</pre> | no |
| <a name="input_istio_ingressgateway_revision"></a> [istio\_ingressgateway\_revision](#input\_istio\_ingressgateway\_revision) | Revision of the istio-ingressgateway application | `number` | `null` | no |
| <a name="input_istio_k8s_config"></a> [istio\_k8s\_config](#input\_istio\_k8s\_config) | Configuration for istio-k8s application | `map(string)` | `{}` | no |
| <a name="input_istio_k8s_platform"></a> [istio\_k8s\_platform](#input\_istio\_k8s\_platform) | Platform configuration for istio-k8s | `string` | `""` | no |
| <a name="input_istio_k8s_revision"></a> [istio\_k8s\_revision](#input\_istio\_k8s\_revision) | Revision of the istio-k8s application | `number` | `null` | no |
| <a name="input_istio_pilot_config"></a> [istio\_pilot\_config](#input\_istio\_pilot\_config) | Configuration for istio-pilot application | `map(string)` | `{}` | no |
| <a name="input_istio_pilot_revision"></a> [istio\_pilot\_revision](#input\_istio\_pilot\_revision) | Revision of the istio-pilot application | `number` | `null` | no |
| <a name="input_katib_controller_config"></a> [katib\_controller\_config](#input\_katib\_controller\_config) | Configuration for katib-controller application | `map(string)` | `{}` | no |
| <a name="input_katib_controller_revision"></a> [katib\_controller\_revision](#input\_katib\_controller\_revision) | Revision of the katib-controller application | `number` | `null` | no |
| <a name="input_katib_db_manager_config"></a> [katib\_db\_manager\_config](#input\_katib\_db\_manager\_config) | Configuration for katib-db-manager application | `map(string)` | `{}` | no |
| <a name="input_katib_db_manager_revision"></a> [katib\_db\_manager\_revision](#input\_katib\_db\_manager\_revision) | Revision of the katib-db-manager application | `number` | `null` | no |
| <a name="input_katib_ui_config"></a> [katib\_ui\_config](#input\_katib\_ui\_config) | Configuration for katib-ui application | `map(string)` | `{}` | no |
| <a name="input_katib_ui_revision"></a> [katib\_ui\_revision](#input\_katib\_ui\_revision) | Revision of the katib-ui application | `number` | `null` | no |
| <a name="input_kfp_api_config"></a> [kfp\_api\_config](#input\_kfp\_api\_config) | Configuration for kfp-api application | `map(string)` | `{}` | no |
| <a name="input_kfp_api_revision"></a> [kfp\_api\_revision](#input\_kfp\_api\_revision) | Revision of the kfp-api application | `number` | `null` | no |
| <a name="input_kfp_metadata_writer_config"></a> [kfp\_metadata\_writer\_config](#input\_kfp\_metadata\_writer\_config) | Configuration for kfp-metadata-writer application | `map(string)` | `{}` | no |
| <a name="input_kfp_metadata_writer_revision"></a> [kfp\_metadata\_writer\_revision](#input\_kfp\_metadata\_writer\_revision) | Revision of the kfp-metadata-writer application | `number` | `null` | no |
| <a name="input_kfp_persistence_config"></a> [kfp\_persistence\_config](#input\_kfp\_persistence\_config) | Configuration for kfp-persistence application | `map(string)` | `{}` | no |
| <a name="input_kfp_persistence_revision"></a> [kfp\_persistence\_revision](#input\_kfp\_persistence\_revision) | Revision of the kfp-persistence application | `number` | `null` | no |
| <a name="input_kfp_profile_controller_config"></a> [kfp\_profile\_controller\_config](#input\_kfp\_profile\_controller\_config) | Configuration for kfp-profile-controller application | `map(string)` | `{}` | no |
| <a name="input_kfp_profile_controller_revision"></a> [kfp\_profile\_controller\_revision](#input\_kfp\_profile\_controller\_revision) | Revision of the kfp-profile-controller application | `number` | `null` | no |
| <a name="input_kfp_schedwf_config"></a> [kfp\_schedwf\_config](#input\_kfp\_schedwf\_config) | Configuration for kfp-schedwf application | `map(string)` | `{}` | no |
| <a name="input_kfp_schedwf_revision"></a> [kfp\_schedwf\_revision](#input\_kfp\_schedwf\_revision) | Revision of the kfp-schedwf application | `number` | `null` | no |
| <a name="input_kfp_ui_config"></a> [kfp\_ui\_config](#input\_kfp\_ui\_config) | Configuration for kfp-ui application | `map(string)` | `{}` | no |
| <a name="input_kfp_ui_revision"></a> [kfp\_ui\_revision](#input\_kfp\_ui\_revision) | Revision of the kfp-ui application | `number` | `null` | no |
| <a name="input_kfp_viewer_config"></a> [kfp\_viewer\_config](#input\_kfp\_viewer\_config) | Configuration for kfp-viewer application | `map(string)` | `{}` | no |
| <a name="input_kfp_viewer_revision"></a> [kfp\_viewer\_revision](#input\_kfp\_viewer\_revision) | Revision of the kfp-viewer application | `number` | `null` | no |
| <a name="input_kfp_viz_config"></a> [kfp\_viz\_config](#input\_kfp\_viz\_config) | Configuration for kfp-viz application | `map(string)` | `{}` | no |
| <a name="input_kfp_viz_revision"></a> [kfp\_viz\_revision](#input\_kfp\_viz\_revision) | Revision of the kfp-viz application | `number` | `null` | no |
| <a name="input_knative_eventing_config"></a> [knative\_eventing\_config](#input\_knative\_eventing\_config) | Configuration for knative-eventing application | `map(string)` | `{}` | no |
| <a name="input_knative_eventing_revision"></a> [knative\_eventing\_revision](#input\_knative\_eventing\_revision) | Revision of the knative-eventing application | `number` | `null` | no |
| <a name="input_knative_operator_config"></a> [knative\_operator\_config](#input\_knative\_operator\_config) | Configuration for knative-operator application | `map(string)` | `{}` | no |
| <a name="input_knative_operator_revision"></a> [knative\_operator\_revision](#input\_knative\_operator\_revision) | Revision of the knative-operator application | `number` | `null` | no |
| <a name="input_knative_serving_config"></a> [knative\_serving\_config](#input\_knative\_serving\_config) | Configuration for knative-serving application | `map(string)` | `{}` | no |
| <a name="input_knative_serving_revision"></a> [knative\_serving\_revision](#input\_knative\_serving\_revision) | Revision of the knative-serving application | `number` | `null` | no |
| <a name="input_kserve_controller_config"></a> [kserve\_controller\_config](#input\_kserve\_controller\_config) | Configuration for kserve-controller application | `map(string)` | `{}` | no |
| <a name="input_kserve_controller_revision"></a> [kserve\_controller\_revision](#input\_kserve\_controller\_revision) | Revision of the kserve-controller application | `number` | `null` | no |
| <a name="input_kubeflow_dashboard_config"></a> [kubeflow\_dashboard\_config](#input\_kubeflow\_dashboard\_config) | Configuration for kubeflow-dashboard application | `map(string)` | `{}` | no |
| <a name="input_kubeflow_dashboard_revision"></a> [kubeflow\_dashboard\_revision](#input\_kubeflow\_dashboard\_revision) | Revision of the kubeflow-dashboard application | `number` | `null` | no |
| <a name="input_kubeflow_profiles_config"></a> [kubeflow\_profiles\_config](#input\_kubeflow\_profiles\_config) | Configuration for kubeflow-profiles application | `map(string)` | `{}` | no |
| <a name="input_kubeflow_profiles_revision"></a> [kubeflow\_profiles\_revision](#input\_kubeflow\_profiles\_revision) | Revision of the kubeflow-profiles application | `number` | `null` | no |
| <a name="input_kubeflow_roles_config"></a> [kubeflow\_roles\_config](#input\_kubeflow\_roles\_config) | Configuration for kubeflow-roles application | `map(string)` | `{}` | no |
| <a name="input_kubeflow_roles_revision"></a> [kubeflow\_roles\_revision](#input\_kubeflow\_roles\_revision) | Revision of the kubeflow-roles application | `number` | `null` | no |
| <a name="input_kubeflow_volumes_config"></a> [kubeflow\_volumes\_config](#input\_kubeflow\_volumes\_config) | Configuration for kubeflow-volumes application | `map(string)` | `{}` | no |
| <a name="input_kubeflow_volumes_revision"></a> [kubeflow\_volumes\_revision](#input\_kubeflow\_volumes\_revision) | Revision of the kubeflow-volumes application | `number` | `null` | no |
| <a name="input_metacontroller_operator_config"></a> [metacontroller\_operator\_config](#input\_metacontroller\_operator\_config) | Configuration for metacontroller-operator application | `map(string)` | `{}` | no |
| <a name="input_metacontroller_operator_revision"></a> [metacontroller\_operator\_revision](#input\_metacontroller\_operator\_revision) | Revision of the metacontroller-operator application | `number` | `null` | no |
| <a name="input_minio_config"></a> [minio\_config](#input\_minio\_config) | Configuration for minio application | `map(string)` | `{}` | no |
| <a name="input_minio_revision"></a> [minio\_revision](#input\_minio\_revision) | Revision of the minio application | `number` | `null` | no |
| <a name="input_mlflow_server_config"></a> [mlflow\_server\_config](#input\_mlflow\_server\_config) | Configuration for mlflow-server application | `map(string)` | `{}` | no |
| <a name="input_mlflow_server_revision"></a> [mlflow\_server\_revision](#input\_mlflow\_server\_revision) | Revision of the mlflow-server application | `number` | `null` | no |
| <a name="input_mlmd_config"></a> [mlmd\_config](#input\_mlmd\_config) | Configuration for mlmd application | `map(string)` | `{}` | no |
| <a name="input_mlmd_revision"></a> [mlmd\_revision](#input\_mlmd\_revision) | Revision of the mlmd application | `number` | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of an existing Juju model (required when create\_model is false) | `string` | `null` | no |
| <a name="input_mysql"></a> [mysql](#input\_mysql) | Configuration for mysql (mysql-k8s) application | <pre>object({<br/>    revision     = optional(number)<br/>    units        = optional(number, 1)<br/>    storage_size = optional(string, "10G")<br/>    config       = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_oidc_gatekeeper_config"></a> [oidc\_gatekeeper\_config](#input\_oidc\_gatekeeper\_config) | Configuration for oidc-gatekeeper application | `map(string)` | `{}` | no |
| <a name="input_oidc_gatekeeper_revision"></a> [oidc\_gatekeeper\_revision](#input\_oidc\_gatekeeper\_revision) | Revision of the oidc-gatekeeper application | `number` | `null` | no |
| <a name="input_pvcviewer_operator_config"></a> [pvcviewer\_operator\_config](#input\_pvcviewer\_operator\_config) | Configuration for pvcviewer-operator application | `map(string)` | `{}` | no |
| <a name="input_pvcviewer_operator_revision"></a> [pvcviewer\_operator\_revision](#input\_pvcviewer\_operator\_revision) | Revision of the pvcviewer-operator application | `number` | `null` | no |
| <a name="input_resource_dispatcher_config"></a> [resource\_dispatcher\_config](#input\_resource\_dispatcher\_config) | Configuration for resource-dispatcher application | `map(string)` | `{}` | no |
| <a name="input_resource_dispatcher_revision"></a> [resource\_dispatcher\_revision](#input\_resource\_dispatcher\_revision) | Revision of the resource-dispatcher application | `number` | `null` | no |
| <a name="input_risk"></a> [risk](#input\_risk) | Value for the risk to be used | `string` | `"edge"` | no |
| <a name="input_service_mesh_type"></a> [service\_mesh\_type](#input\_service\_mesh\_type) | Which service mesh component to deploy: 'istio' (sidecar) or 'ambient' | `string` | `"sidecar"` | no |
| <a name="input_tensorboard_controller_config"></a> [tensorboard\_controller\_config](#input\_tensorboard\_controller\_config) | Configuration for tensorboard-controller application | `map(string)` | `{}` | no |
| <a name="input_tensorboard_controller_revision"></a> [tensorboard\_controller\_revision](#input\_tensorboard\_controller\_revision) | Revision of the tensorboard-controller application | `number` | `null` | no |
| <a name="input_tensorboards_web_app_config"></a> [tensorboards\_web\_app\_config](#input\_tensorboards\_web\_app\_config) | Configuration for tensorboards-web-app application | `map(string)` | `{}` | no |
| <a name="input_tensorboards_web_app_revision"></a> [tensorboards\_web\_app\_revision](#input\_tensorboards\_web\_app\_revision) | Revision of the tensorboards-web-app application | `number` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

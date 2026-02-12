
resource "juju_integration" "argo_controller_minio" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.argo_controller.app_name
    endpoint = module.argo_controller.requires.object_storage
  }

  application {
    name     = module.minio.app_name
    endpoint = module.minio.provides.object_storage
  }
}

resource "juju_integration" "dex_auth_oidc_gatekeeper_dex_oidc_config" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.dex_auth.app_name
    endpoint = module.dex_auth.provides.dex_oidc_config
  }

  application {
    name     = module.oidc_gatekeeper.app_name
    endpoint = module.oidc_gatekeeper.requires.dex_oidc_config
  }
}

resource "juju_integration" "dex_auth_oidc_gatekeeper_oidc_client" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.dex_auth.app_name
    endpoint = module.dex_auth.requires.oidc_client
  }

  application {
    name     = module.oidc_gatekeeper.app_name
    endpoint = module.oidc_gatekeeper.provides.oidc_client
  }
}

resource "juju_integration" "katib_db_manager_katib_controller_k8s_service_info" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_db_manager.app_name
    endpoint = module.katib_db_manager.provides.k8s_service_info
  }

  application {
    name     = module.katib_controller.app_name
    endpoint = module.katib_controller.requires.k8s_service_info
  }
}

resource "juju_integration" "katib_db_manager_katib_db_relational_db" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_db_manager.app_name
    endpoint = module.katib_db_manager.requires.relational_db
  }

  application {
    name     = module.katib_db.app_name
    endpoint = module.katib_db.provides.database
  }
}

resource "juju_integration" "kfp_api_kfp_db_database" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.requires.relational_db
  }

  application {
    name     = module.kfp_db.app_name
    endpoint = module.kfp_db.provides.database
  }
}

resource "juju_integration" "kfp_api_kfp_persistence_database" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.provides.kfp_api
  }

  application {
    name     = module.kfp_persistence.app_name
    endpoint = module.kfp_persistence.requires.kfp_api
  }
}

resource "juju_integration" "kfp_api_kfp_ui_database" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.provides.kfp_api
  }

  application {
    name     = module.kfp_ui.app_name
    endpoint = module.kfp_ui.requires.kfp_api
  }
}

resource "juju_integration" "kfp_api_kfp_viz_database" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.requires.kfp_viz
  }

  application {
    name     = module.kfp_viz.app_name
    endpoint = module.kfp_viz.provides.kfp_viz
  }
}

resource "juju_integration" "kfp_api_minio_object_storage" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.requires.object_storage
  }

  application {
    name     = module.minio.app_name
    endpoint = module.minio.provides.object_storage
  }
}

resource "juju_integration" "kfp_profile_controller_minio_object_storage" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_profile_controller.app_name
    endpoint = module.kfp_profile_controller.requires.object_storage
  }

  application {
    name     = module.minio.app_name
    endpoint = module.minio.provides.object_storage
  }
}

resource "juju_integration" "kfp_ui_minio_object_storage" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_ui.app_name
    endpoint = module.kfp_ui.requires.object_storage
  }

  application {
    name     = module.minio.app_name
    endpoint = module.minio.provides.object_storage
  }
}

resource "juju_integration" "kserve_controller_knative_serving_local_gateway" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.requires.local_gateway
  }

  application {
    name     = module.knative_serving.app_name
    endpoint = module.knative_serving.provides.local_gateway
  }
}

resource "juju_integration" "kubeflow_profiles_kubeflow_dashboard_kubeflow_profiles" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_profiles.app_name
    endpoint = module.kubeflow_profiles.provides.kubeflow_profiles
  }

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.requires.kubeflow_profiles
  }
}

resource "juju_integration" "kubeflow_dashboard_jupyter_ui_links" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.links
  }

  application {
    name     = module.jupyter_ui.app_name
    endpoint = module.jupyter_ui.requires.dashboard_links
  }
}

resource "juju_integration" "kubeflow_dashboard_katib_ui_links" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.links
  }

  application {
    name     = module.katib_ui.app_name
    endpoint = module.katib_ui.requires.dashboard_links
  }
}

resource "juju_integration" "kubeflow_dashboard_kfp_ui_links" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.links
  }

  application {
    name     = module.kfp_ui.app_name
    endpoint = module.kfp_ui.requires.dashboard_links
  }
}

resource "juju_integration" "kubeflow_dashboard_kubeflow_trainer_links" {
  count = var.kubeflow_trainer_v2 ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.links
  }

  application {
    name     = module.kubeflow_trainer[0].app_name
    endpoint = module.kubeflow_trainer[0].requires.dashboard_links
  }
}

resource "juju_integration" "kubeflow_dashboard_kubeflow_volumes_links" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.links
  }

  application {
    name     = module.kubeflow_volumes.app_name
    endpoint = module.kubeflow_volumes.requires.dashboard_links
  }
}

resource "juju_integration" "kubeflow_dashboard_tensorboards_web_app_links" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.links
  }

  application {
    name     = module.tensorboards_web_app.app_name
    endpoint = module.tensorboards_web_app.requires.dashboard_links
  }
}

resource "juju_integration" "kubeflow_dashboard_training_operator_links" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.links
  }

  application {
    name     = module.training_operator.app_name
    endpoint = module.training_operator.requires.dashboard_links
  }
}

resource "juju_integration" "mlmd_envoy_grpc" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.mlmd.app_name
    endpoint = module.mlmd.provides.grpc
  }

  application {
    name     = module.envoy.app_name
    endpoint = module.envoy.requires.grpc
  }
}

resource "juju_integration" "mlmd_kfp_metadata_writer_grpc" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.mlmd.app_name
    endpoint = module.mlmd.provides.grpc
  }

  application {
    name     = module.kfp_metadata_writer.app_name
    endpoint = module.kfp_metadata_writer.requires.grpc
  }
}

resource "juju_integration" "istio_beacon_k8s_admission_webhook" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.admission_webhook.app_name
    endpoint = module.admission_webhook.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_dex_auth" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.dex_auth.app_name
    endpoint = module.dex_auth.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_katib_controller" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.katib_controller.app_name
    endpoint = module.katib_controller.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_katib_ui" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.katib_ui.app_name
    endpoint = module.katib_ui.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kfp_api" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kfp_persistence" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kfp_persistence.app_name
    endpoint = module.kfp_persistence.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kfp_profile_controller" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kfp_profile_controller.app_name
    endpoint = module.kfp_profile_controller.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kfp_schedwf" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kfp_schedwf.app_name
    endpoint = module.kfp_schedwf.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kfp_ui" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kfp_ui.app_name
    endpoint = module.kfp_ui.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kfp_viz" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kfp_viz.app_name
    endpoint = module.kfp_viz.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kubeflow_dashboard" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kubeflow_profiles" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kubeflow_profiles.app_name
    endpoint = module.kubeflow_profiles.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kubeflow_volumes" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kubeflow_volumes.app_name
    endpoint = module.kubeflow_volumes.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_minio" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.minio.app_name
    endpoint = module.minio.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_oidc_gatekeeper" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.oidc_gatekeeper.app_name
    endpoint = module.oidc_gatekeeper.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_pvcviewer_operator" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.pvcviewer_operator.app_name
    endpoint = module.pvcviewer_operator.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_tensorboard_controller" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.tensorboard_controller.app_name
    endpoint = module.tensorboard_controller.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_tensorboards_web_app" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.tensorboards_web_app.app_name
    endpoint = module.tensorboards_web_app.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_jupyter_controller" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.jupyter_controller.app_name
    endpoint = module.jupyter_controller.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_jupyter_ui" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.jupyter_ui.app_name
    endpoint = module.jupyter_ui.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_envoy" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.envoy.app_name
    endpoint = module.envoy.requires.service_mesh
  }
}

resource "juju_integration" "istio_beacon_k8s_kserve_controller" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_beacon_k8s.name
    endpoint = "service-mesh"
  }

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.requires.service_mesh
  }
}

resource "juju_integration" "istio_ingress_k8s_kubeflow_volumes" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.kubeflow_volumes.app_name
    endpoint = module.kubeflow_volumes.requires.istio_ingress_route
  }
}

resource "juju_integration" "istio_ingress_k8s_kfp_ui" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.kfp_ui.app_name
    endpoint = module.kfp_ui.requires.istio_ingress_route
  }
}

resource "juju_integration" "istio_ingress_k8s_envoy" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.envoy.app_name
    endpoint = module.envoy.requires.istio_ingress_route
  }
}

resource "juju_integration" "istio_ingress_k8s_katib_ui" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.katib_ui.app_name
    endpoint = module.katib_ui.requires.istio_ingress_route
  }
}

resource "juju_integration" "istio_ingress_k8s_kubeflow_dashboard" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.requires.istio_ingress_route
  }
}

resource "juju_integration" "istio_ingress_k8s_jupyter_ui" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.jupyter_ui.app_name
    endpoint = module.jupyter_ui.requires.istio_ingress_route
  }
}

resource "juju_integration" "istio_ingress_k8s_tensorboards_web_app" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route"
  }

  application {
    name     = module.tensorboards_web_app.app_name
    endpoint = module.tensorboards_web_app.requires.istio_ingress_route
  }
}

resource "juju_integration" "oidc_gatekeeper_istio_ingress_k8s_unauthenticated" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.oidc_gatekeeper.app_name
    endpoint = module.oidc_gatekeeper.requires.istio_ingress_route_unauthenticated
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route-unauthenticated"
  }
}

resource "juju_integration" "oidc_gatekeeper_istio_ingress_k8s_forward_auth" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.oidc_gatekeeper.app_name
    endpoint = module.oidc_gatekeeper.provides.forward_auth
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "forward-auth"
  }
}

resource "juju_integration" "dex_auth_istio_ingress_k8s_unauthenticated" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.dex_auth.app_name
    endpoint = module.dex_auth.requires.istio_ingress_route_unauthenticated
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-route-unauthenticated"
  }
}

resource "juju_integration" "istio_k8s_istio_ingress_k8s_ingress_config" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = juju_application.istio_k8s.name
    endpoint = "istio-ingress-config"
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "istio-ingress-config"
  }
}

resource "juju_integration" "jupyter_controller_istio_ingress_k8s_gateway_metadata" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.jupyter_controller.app_name
    endpoint = module.jupyter_controller.requires.gateway_metadata
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "gateway-metadata"
  }
}

resource "juju_integration" "pvcviewer_operator_istio_ingress_k8s_gateway_metadata" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.pvcviewer_operator.app_name
    endpoint = module.pvcviewer_operator.requires.gateway_metadata
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "gateway-metadata"
  }
}

resource "juju_integration" "tensorboard_controller_istio_ingress_k8s_gateway_metadata" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.tensorboard_controller.app_name
    endpoint = module.tensorboard_controller.requires.gateway_metadata
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "gateway-metadata"
  }
}

resource "juju_integration" "kserve_controller_istio_ingress_k8s_gateway_metadata" {
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.requires.gateway_metadata
  }

  application {
    name     = juju_application.istio_ingress_k8s.name
    endpoint = "gateway-metadata"
  }
}

# TODO: Update to use a reusable module instead of defining
# a `juju_application` resource
resource "juju_application" "opentelemetry_collector_k8s" {
  count = var.cos_configuration && var.existing_opentelemetry_collector_name == null ? 1 : 0
  charm {
    name     = "opentelemetry-collector-k8s"
    channel  = "2/stable"
    revision = var.opentelemetry_collector_k8s_revision
  }
  model = var.create_model ? juju_model.kubeflow[0].name : local.model
  name  = "opentelemetry-collector-k8s-kubeflow"
  storage_directives = {
    persisted = var.opentelemetry_collector_k8s_size
  }
  trust = true
  units = 1
}

resource "juju_integration" "argo_controller_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.argo_controller.app_name
    endpoint = module.argo_controller.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "argo_controller_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.argo_controller.app_name
    endpoint = module.argo_controller.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "argo_controller_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.argo_controller.app_name
    endpoint = module.argo_controller.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "admission_webhook_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.admission_webhook.app_name
    endpoint = module.admission_webhook.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "dex_auth_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.dex_auth.app_name
    endpoint = module.dex_auth.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "dex_auth_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.dex_auth.app_name
    endpoint = module.dex_auth.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "dex_auth_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.dex_auth.app_name
    endpoint = module.dex_auth.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "envoy_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.envoy.app_name
    endpoint = module.envoy.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "envoy_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.envoy.app_name
    endpoint = module.envoy.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "envoy_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.envoy.app_name
    endpoint = module.envoy.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "istio_ingressgateway_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.istio_ingressgateway.app_name
    endpoint = module.istio_ingressgateway.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "istio_pilot_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.istio_pilot.app_name
    endpoint = module.istio_pilot.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "istio_pilot_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.istio_pilot.app_name
    endpoint = module.istio_pilot.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "jupyter_controller_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.jupyter_controller.app_name
    endpoint = module.jupyter_controller.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "jupyter_controller_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.jupyter_controller.app_name
    endpoint = module.jupyter_controller.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "jupyter_controller_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.jupyter_controller.app_name
    endpoint = module.jupyter_controller.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "jupyter_ui_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.jupyter_ui.app_name
    endpoint = module.jupyter_ui.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "katib_controller_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_controller.app_name
    endpoint = module.katib_controller.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "katib_controller_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_controller.app_name
    endpoint = module.katib_controller.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "katib_controller_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_controller.app_name
    endpoint = module.katib_controller.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "katib_db_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_db.app_name
    endpoint = module.katib_db.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "katib_db_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_db.app_name
    endpoint = module.katib_db.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "katib_db_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_db.app_name
    endpoint = module.katib_db.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "katib_db_manager_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_db_manager.app_name
    endpoint = module.katib_db_manager.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "katib_ui_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.katib_ui.app_name
    endpoint = module.katib_ui.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_api_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "kfp_api_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kfp_api_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_api.app_name
    endpoint = module.kfp_api.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}


resource "juju_integration" "kfp_db_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_db.app_name
    endpoint = module.kfp_db.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "kfp_db_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_db.app_name
    endpoint = module.kfp_db.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kfp_db_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_db.app_name
    endpoint = module.kfp_db.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_metadata_writer_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_metadata_writer.app_name
    endpoint = module.kfp_metadata_writer.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_persistence_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_persistence.app_name
    endpoint = module.kfp_persistence.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_profile_controller_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_profile_controller.app_name
    endpoint = module.kfp_profile_controller.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_schedwf_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_schedwf.app_name
    endpoint = module.kfp_schedwf.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_ui_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_ui.app_name
    endpoint = module.kfp_ui.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_viewer_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_viewer.app_name
    endpoint = module.kfp_viewer.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_viz_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kfp_viz.app_name
    endpoint = module.kfp_viz.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "knative_eventing_knative_operator_otel_collector" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.knative_eventing.app_name
    endpoint = module.knative_eventing.requires.otel_collector
  }

  application {
    name     = module.knative_operator.app_name
    endpoint = module.knative_operator.provides.otel_collector
  }
}

resource "juju_integration" "knative_serving_knative_operator_otel_collector" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.knative_serving.app_name
    endpoint = module.knative_serving.requires.otel_collector
  }

  application {
    name     = module.knative_operator.app_name
    endpoint = module.knative_operator.provides.otel_collector
  }
}

resource "juju_integration" "knative_operator_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.knative_operator.app_name
    endpoint = module.knative_operator.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "knative_operator_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.knative_operator.app_name
    endpoint = module.knative_operator.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kserve_controller_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kserve_controller_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kubeflow_dashboard_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kubeflow_dashboard_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "kubeflow_dashboard_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_dashboard.app_name
    endpoint = module.kubeflow_dashboard.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}


resource "juju_integration" "kubeflow_profiles_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_profiles.app_name
    endpoint = module.kubeflow_profiles.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kubeflow_profiles_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_profiles.app_name
    endpoint = module.kubeflow_profiles.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kubeflow_trainer_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration && var.kubeflow_trainer_v2 ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_trainer[0].app_name
    endpoint = module.kubeflow_trainer[0].provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "kubeflow_trainer_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration && var.kubeflow_trainer_v2 ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_trainer[0].app_name
    endpoint = module.kubeflow_trainer[0].provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}


resource "juju_integration" "kubeflow_volumes_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.kubeflow_volumes.app_name
    endpoint = module.kubeflow_volumes.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "metacontroller_operator_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.metacontroller_operator.app_name
    endpoint = module.metacontroller_operator.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "metacontroller_operator_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.metacontroller_operator.app_name
    endpoint = module.metacontroller_operator.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "mlmd_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.mlmd.app_name
    endpoint = module.mlmd.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "minio_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.minio.app_name
    endpoint = module.minio.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "minio_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.minio.app_name
    endpoint = module.minio.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "oidc_gatekeeper_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.oidc_gatekeeper.app_name
    endpoint = module.oidc_gatekeeper.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "pvcviewer_operator_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.pvcviewer_operator.app_name
    endpoint = module.pvcviewer_operator.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "pvcviewer_operator_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.pvcviewer_operator.app_name
    endpoint = module.pvcviewer_operator.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "pvcviewer_operator_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.pvcviewer_operator.app_name
    endpoint = module.pvcviewer_operator.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "tensorboard_controller_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.tensorboard_controller.app_name
    endpoint = module.tensorboard_controller.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "tensorboard_controller_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.tensorboard_controller.app_name
    endpoint = module.tensorboard_controller.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "tensorboards_web_app_opentelemetry_collector_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.tensorboards_web_app.app_name
    endpoint = module.tensorboards_web_app.requires.logging
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "training_operator_opentelemetry_collector_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.training_operator.app_name
    endpoint = module.training_operator.provides.grafana_dashboard
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "training_operator_opentelemetry_collector_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.create_model ? juju_model.kubeflow[0].name : local.model

  application {
    name     = module.training_operator.app_name
    endpoint = module.training_operator.provides.metrics_endpoint
  }

  application {
    name     = var.existing_opentelemetry_collector_name == null ? juju_application.opentelemetry_collector_k8s[count.index].name : var.existing_opentelemetry_collector_name
    endpoint = "metrics-endpoint"
  }
}

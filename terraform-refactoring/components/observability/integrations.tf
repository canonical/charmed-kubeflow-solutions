# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# ---------------------------------------------------------------------------
# Cross-model COS offer data sources
# ---------------------------------------------------------------------------

data "juju_offer" "grafana_dashboards" {
  url = var.dashboards_offer
}

data "juju_offer" "loki_logging" {
  url = var.logging_offer
}

data "juju_offer" "prometheus_receive_remote_write" {
  url = var.metrics_offer
}

# ---------------------------------------------------------------------------
# Cross-model COS integrations
# ---------------------------------------------------------------------------

resource "juju_integration" "opentelemetry_collector_k8s_grafana_dashboards" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-provider"
  }

  application {
    offer_url = data.juju_offer.grafana_dashboards.url
  }
}

resource "juju_integration" "opentelemetry_collector_k8s_loki" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "loki-push"
  }

  application {
    offer_url = data.juju_offer.loki_logging.url
  }
}

resource "juju_integration" "opentelemetry_collector_k8s_prometheus" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "send-remote-write"
  }

  application {
    offer_url = data.juju_offer.prometheus_receive_remote_write.url
  }
}

# ---------------------------------------------------------------------------
# Grafana dashboard integrations
# ---------------------------------------------------------------------------

resource "juju_integration" "kubeflow_dashboard_grafana_dashboard" {
  count      = var.kubeflow_dashboard_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kubeflow_dashboard_grafana_dashboard.name
    endpoint = var.kubeflow_dashboard_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "metacontroller_operator_grafana_dashboard" {
  count      = var.metacontroller_operator_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.metacontroller_operator_grafana_dashboard.name
    endpoint = var.metacontroller_operator_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "pvcviewer_operator_grafana_dashboard" {
  count      = var.pvcviewer_operator_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.pvcviewer_operator_grafana_dashboard.name
    endpoint = var.pvcviewer_operator_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "dex_auth_grafana_dashboard" {
  count      = var.dex_auth_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.dex_auth_grafana_dashboard.name
    endpoint = var.dex_auth_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "argo_controller_grafana_dashboard" {
  count      = var.argo_controller_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.argo_controller_grafana_dashboard.name
    endpoint = var.argo_controller_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "envoy_grafana_dashboard" {
  count      = var.envoy_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.envoy_grafana_dashboard.name
    endpoint = var.envoy_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "kfp_api_grafana_dashboard" {
  count      = var.kfp_api_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_api_grafana_dashboard.name
    endpoint = var.kfp_api_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "katib_controller_grafana_dashboard" {
  count      = var.katib_controller_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.katib_controller_grafana_dashboard.name
    endpoint = var.katib_controller_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "jupyter_controller_grafana_dashboard" {
  count      = var.jupyter_controller_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.jupyter_controller_grafana_dashboard.name
    endpoint = var.jupyter_controller_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "training_operator_grafana_dashboard" {
  count      = var.training_operator_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.training_operator_grafana_dashboard.name
    endpoint = var.training_operator_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "kubeflow_trainer_grafana_dashboard" {
  count      = var.kubeflow_trainer_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kubeflow_trainer_grafana_dashboard.name
    endpoint = var.kubeflow_trainer_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "istio_pilot_grafana_dashboard" {
  count      = var.istio_pilot_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.istio_pilot_grafana_dashboard.name
    endpoint = var.istio_pilot_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "minio_grafana_dashboard" {
  count      = var.minio_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.minio_grafana_dashboard.name
    endpoint = var.minio_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

# ---------------------------------------------------------------------------
# Metrics endpoint integrations
# ---------------------------------------------------------------------------

resource "juju_integration" "kubeflow_dashboard_metrics_endpoint" {
  count      = var.kubeflow_dashboard_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kubeflow_dashboard_metrics_endpoint.name
    endpoint = var.kubeflow_dashboard_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kubeflow_profiles_metrics_endpoint" {
  count      = var.kubeflow_profiles_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kubeflow_profiles_metrics_endpoint.name
    endpoint = var.kubeflow_profiles_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "metacontroller_operator_metrics_endpoint" {
  count      = var.metacontroller_operator_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.metacontroller_operator_metrics_endpoint.name
    endpoint = var.metacontroller_operator_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "pvcviewer_operator_metrics_endpoint" {
  count      = var.pvcviewer_operator_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.pvcviewer_operator_metrics_endpoint.name
    endpoint = var.pvcviewer_operator_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "dex_auth_metrics_endpoint" {
  count      = var.dex_auth_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.dex_auth_metrics_endpoint.name
    endpoint = var.dex_auth_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "argo_controller_metrics_endpoint" {
  count      = var.argo_controller_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.argo_controller_metrics_endpoint.name
    endpoint = var.argo_controller_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "envoy_metrics_endpoint" {
  count      = var.envoy_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.envoy_metrics_endpoint.name
    endpoint = var.envoy_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kfp_api_metrics_endpoint" {
  count      = var.kfp_api_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_api_metrics_endpoint.name
    endpoint = var.kfp_api_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "katib_controller_metrics_endpoint" {
  count      = var.katib_controller_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.katib_controller_metrics_endpoint.name
    endpoint = var.katib_controller_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kserve_controller_metrics_endpoint" {
  count      = var.kserve_controller_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kserve_controller_metrics_endpoint.name
    endpoint = var.kserve_controller_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "knative_operator_metrics_endpoint" {
  count      = var.knative_operator_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.knative_operator_metrics_endpoint.name
    endpoint = var.knative_operator_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "jupyter_controller_metrics_endpoint" {
  count      = var.jupyter_controller_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.jupyter_controller_metrics_endpoint.name
    endpoint = var.jupyter_controller_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "training_operator_metrics_endpoint" {
  count      = var.training_operator_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.training_operator_metrics_endpoint.name
    endpoint = var.training_operator_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kubeflow_trainer_metrics_endpoint" {
  count      = var.kubeflow_trainer_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kubeflow_trainer_metrics_endpoint.name
    endpoint = var.kubeflow_trainer_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "tensorboard_controller_metrics_endpoint" {
  count      = var.tensorboard_controller_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.tensorboard_controller_metrics_endpoint.name
    endpoint = var.tensorboard_controller_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "istio_ingressgateway_metrics_endpoint" {
  count      = var.istio_ingressgateway_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.istio_ingressgateway_metrics_endpoint.name
    endpoint = var.istio_ingressgateway_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "istio_pilot_metrics_endpoint" {
  count      = var.istio_pilot_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.istio_pilot_metrics_endpoint.name
    endpoint = var.istio_pilot_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "minio_metrics_endpoint" {
  count      = var.minio_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.minio_metrics_endpoint.name
    endpoint = var.minio_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

# ---------------------------------------------------------------------------
# Logging integrations (collector acts as Loki log sink)
# ---------------------------------------------------------------------------

resource "juju_integration" "admission_webhook_logging" {
  count      = var.admission_webhook_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.admission_webhook_logging.name
    endpoint = var.admission_webhook_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kubeflow_dashboard_logging" {
  count      = var.kubeflow_dashboard_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kubeflow_dashboard_logging.name
    endpoint = var.kubeflow_dashboard_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kubeflow_profiles_logging" {
  count      = var.kubeflow_profiles_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kubeflow_profiles_logging.name
    endpoint = var.kubeflow_profiles_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kubeflow_volumes_logging" {
  count      = var.kubeflow_volumes_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kubeflow_volumes_logging.name
    endpoint = var.kubeflow_volumes_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "pvcviewer_operator_logging" {
  count      = var.pvcviewer_operator_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.pvcviewer_operator_logging.name
    endpoint = var.pvcviewer_operator_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "dex_auth_logging" {
  count      = var.dex_auth_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.dex_auth_logging.name
    endpoint = var.dex_auth_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "oidc_gatekeeper_logging" {
  count      = var.oidc_gatekeeper_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.oidc_gatekeeper_logging.name
    endpoint = var.oidc_gatekeeper_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "argo_controller_logging" {
  count      = var.argo_controller_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.argo_controller_logging.name
    endpoint = var.argo_controller_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "envoy_logging" {
  count      = var.envoy_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.envoy_logging.name
    endpoint = var.envoy_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_api_logging" {
  count      = var.kfp_api_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_api_logging.name
    endpoint = var.kfp_api_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_metadata_writer_logging" {
  count      = var.kfp_metadata_writer_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_metadata_writer_logging.name
    endpoint = var.kfp_metadata_writer_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_persistence_logging" {
  count      = var.kfp_persistence_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_persistence_logging.name
    endpoint = var.kfp_persistence_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_profile_controller_logging" {
  count      = var.kfp_profile_controller_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_profile_controller_logging.name
    endpoint = var.kfp_profile_controller_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_schedwf_logging" {
  count      = var.kfp_schedwf_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_schedwf_logging.name
    endpoint = var.kfp_schedwf_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_ui_logging" {
  count      = var.kfp_ui_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_ui_logging.name
    endpoint = var.kfp_ui_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_viewer_logging" {
  count      = var.kfp_viewer_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_viewer_logging.name
    endpoint = var.kfp_viewer_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kfp_viz_logging" {
  count      = var.kfp_viz_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kfp_viz_logging.name
    endpoint = var.kfp_viz_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "mlmd_logging" {
  count      = var.mlmd_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.mlmd_logging.name
    endpoint = var.mlmd_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "katib_controller_logging" {
  count      = var.katib_controller_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.katib_controller_logging.name
    endpoint = var.katib_controller_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "katib_db_manager_logging" {
  count      = var.katib_db_manager_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.katib_db_manager_logging.name
    endpoint = var.katib_db_manager_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "katib_ui_logging" {
  count      = var.katib_ui_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.katib_ui_logging.name
    endpoint = var.katib_ui_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "kserve_controller_logging" {
  count      = var.kserve_controller_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.kserve_controller_logging.name
    endpoint = var.kserve_controller_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "knative_operator_logging" {
  count      = var.knative_operator_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.knative_operator_logging.name
    endpoint = var.knative_operator_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "jupyter_controller_logging" {
  count      = var.jupyter_controller_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.jupyter_controller_logging.name
    endpoint = var.jupyter_controller_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "jupyter_ui_logging" {
  count      = var.jupyter_ui_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.jupyter_ui_logging.name
    endpoint = var.jupyter_ui_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "tensorboard_controller_logging" {
  count      = var.tensorboard_controller_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.tensorboard_controller_logging.name
    endpoint = var.tensorboard_controller_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

resource "juju_integration" "tensorboards_web_app_logging" {
  count      = var.tensorboards_web_app_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.tensorboards_web_app_logging.name
    endpoint = var.tensorboards_web_app_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

# ---------------------------------------------------------------------------
# MLflow integrations
# ---------------------------------------------------------------------------

resource "juju_integration" "mlflow_server_grafana_dashboard" {
  count      = var.mlflow_server_grafana_dashboard != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.mlflow_server_grafana_dashboard.name
    endpoint = var.mlflow_server_grafana_dashboard.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "mlflow_server_metrics_endpoint" {
  count      = var.mlflow_server_metrics_endpoint != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.mlflow_server_metrics_endpoint.name
    endpoint = var.mlflow_server_metrics_endpoint.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "mlflow_server_logging" {
  count      = var.mlflow_server_logging != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = var.mlflow_server_logging.name
    endpoint = var.mlflow_server_logging.endpoint
  }

  application {
    name     = juju_application.opentelemetry_collector_k8s.name
    endpoint = "receive-loki-logs"
  }
}

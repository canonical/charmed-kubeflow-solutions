# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Argo Controller object storage integration (minio:object-storage -> argo-controller)

resource "juju_integration" "argo_controller_object_storage" {
  count      = var.object_storage != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.argo_controller.name
    endpoint = "object-storage"
  }

  application {
    name      = var.object_storage.kind == "endpoint" ? var.object_storage.name : null
    endpoint  = var.object_storage.kind == "endpoint" ? var.object_storage.endpoint : null
    offer_url = var.object_storage.kind == "offer" ? var.object_storage.url : null
  }
}

# KFP API to MySQL database integration (cross-component)
# Supports both endpoint and offer kinds
resource "juju_integration" "kfp_api_mysql_database" {
  count      = var.mysql_database != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_api.name
    endpoint = "relational-db"
  }

  application {
    name      = var.mysql_database.kind == "endpoint" ? var.mysql_database.name : null
    endpoint  = var.mysql_database.kind == "endpoint" ? var.mysql_database.endpoint : null
    offer_url = var.mysql_database.kind == "offer" ? var.mysql_database.url : null
  }
}

# Object storage integrations (minio:object-storage -> KFP apps)

resource "juju_integration" "kfp_api_object_storage" {
  count      = var.object_storage != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_api.name
    endpoint = "object-storage"
  }

  application {
    name      = var.object_storage.kind == "endpoint" ? var.object_storage.name : null
    endpoint  = var.object_storage.kind == "endpoint" ? var.object_storage.endpoint : null
    offer_url = var.object_storage.kind == "offer" ? var.object_storage.url : null
  }
}

resource "juju_integration" "kfp_profile_controller_object_storage" {
  count      = var.object_storage != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_profile_controller.name
    endpoint = "object-storage"
  }

  application {
    name      = var.object_storage.kind == "endpoint" ? var.object_storage.name : null
    endpoint  = var.object_storage.kind == "endpoint" ? var.object_storage.endpoint : null
    offer_url = var.object_storage.kind == "offer" ? var.object_storage.url : null
  }
}

resource "juju_integration" "kfp_ui_object_storage" {
  count      = var.object_storage != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_ui.name
    endpoint = "object-storage"
  }

  application {
    name      = var.object_storage.kind == "endpoint" ? var.object_storage.name : null
    endpoint  = var.object_storage.kind == "endpoint" ? var.object_storage.endpoint : null
    offer_url = var.object_storage.kind == "offer" ? var.object_storage.url : null
  }
}

# MLMD gRPC integration (mlmd -> kfp-metadata-writer, intra-component)

resource "juju_integration" "kfp_metadata_writer_grpc" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_metadata_writer.name
    endpoint = "grpc"
  }

  application {
    name     = juju_application.mlmd.name
    endpoint = "grpc"
  }
}

# Envoy gRPC relay integration (mlmd:grpc -> envoy:grpc, intra-component)

resource "juju_integration" "envoy_mlmd_grpc" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.envoy.name
    endpoint = "grpc"
  }

  application {
    name     = juju_application.mlmd.name
    endpoint = "grpc"
  }
}

# Kubeflow Dashboard links integration (kubeflow-dashboard:dashboard-links -> kfp-ui)

resource "juju_integration" "kfp_ui_dashboard_links" {
  count      = var.dashboard_links != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_ui.name
    endpoint = "dashboard-links"
  }

  application {
    name      = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.name : null
    endpoint  = var.dashboard_links.kind == "endpoint" ? var.dashboard_links.endpoint : null
    offer_url = var.dashboard_links.kind == "offer" ? var.dashboard_links.url : null
  }
}

# KFP API to KFP Persistence integration
resource "juju_integration" "kfp_api_kfp_persistence" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_api.name
    endpoint = "kfp-api"
  }

  application {
    name     = juju_application.kfp_persistence.name
    endpoint = "kfp-api"
  }
}

# KFP API to KFP UI integration
resource "juju_integration" "kfp_api_kfp_ui" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_api.name
    endpoint = "kfp-api"
  }

  application {
    name     = juju_application.kfp_ui.name
    endpoint = "kfp-api"
  }
}

# KFP API to KFP Persistence gRPC integration
resource "juju_integration" "kfp_api_kfp_persistence_grpc" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_api.name
    endpoint = "kfp-api-grpc"
  }

  application {
    name     = juju_application.kfp_persistence.name
    endpoint = "kfp-api-grpc"
  }
}

# KFP API to KFP Scheduled Workflow gRPC integration
resource "juju_integration" "kfp_api_kfp_schedwf_grpc" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_api.name
    endpoint = "kfp-api-grpc"
  }

  application {
    name     = juju_application.kfp_schedwf.name
    endpoint = "kfp-api-grpc"
  }
}

# KFP API to KFP Viz integration
resource "juju_integration" "kfp_api_kfp_viz" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_api.name
    endpoint = "kfp-viz"
  }

  application {
    name     = juju_application.kfp_viz.name
    endpoint = "kfp-viz"
  }
}

# Ambient service-mesh integrations (istio-beacon-k8s:service-mesh -> KFP apps)

resource "juju_integration" "kfp_api_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_api.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "kfp_persistence_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_persistence.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "kfp_profile_controller_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_profile_controller.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "kfp_schedwf_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_schedwf.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "kfp_ui_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_ui.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

resource "juju_integration" "kfp_viz_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_viz.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

# Ambient istio-ingress-route integration (istio-ingress-k8s:istio-ingress-route -> kfp-ui)

resource "juju_integration" "kfp_ui_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_ui.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}

# Sidecar ingress integration (istio-pilot:ingress -> kfp-ui)

resource "juju_integration" "kfp_ui_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kfp_ui.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# Sidecar ingress integration (istio-pilot:ingress -> envoy)

resource "juju_integration" "envoy_ingress" {
  count      = var.ingress != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.envoy.name
    endpoint = "ingress"
  }

  application {
    name      = var.ingress.kind == "endpoint" ? var.ingress.name : null
    endpoint  = var.ingress.kind == "endpoint" ? var.ingress.endpoint : null
    offer_url = var.ingress.kind == "offer" ? var.ingress.url : null
  }
}

# Ambient service-mesh integration (istio-beacon-k8s:service-mesh -> envoy)

resource "juju_integration" "envoy_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.envoy.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}

# Ambient istio-ingress-route integration (istio-ingress-k8s:istio-ingress-route -> envoy)

resource "juju_integration" "envoy_istio_ingress_route" {
  count      = var.istio_ingress_route != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.envoy.name
    endpoint = "istio-ingress-route"
  }

  application {
    name      = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.name : null
    endpoint  = var.istio_ingress_route.kind == "endpoint" ? var.istio_ingress_route.endpoint : null
    offer_url = var.istio_ingress_route.kind == "offer" ? var.istio_ingress_route.url : null
  }
}

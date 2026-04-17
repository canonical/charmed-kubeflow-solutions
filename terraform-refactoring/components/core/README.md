# Core Component Module

Terraform component module for deploying core Kubeflow services using Juju charms.

## Overview

This component deploys the foundational Kubeflow services required by all other components:

| Application | Charm | Role |
|---|---|---|
| `dex-auth` | `dex-auth` | OpenID Connect identity provider |
| `oidc-gatekeeper` | `oidc-gatekeeper` | HTTP authorization gateway |
| `minio` | `minio` | Object storage for ML artifacts |
| `mlmd` | `mlmd` | ML Metadata service |
| `envoy` | `envoy` | L7 proxy for gRPC communication |
| `kubeflow-dashboard` | `kubeflow-dashboard` | Web UI for Kubeflow |
| `kubeflow-profiles` | `kubeflow-profiles` | Multi-tenancy profile management |
| `kubeflow-roles` | `kubeflow-roles` | RBAC role management |
| `kubeflow-volumes` | `kubeflow-volumes` | Volume management for notebooks |
| `metacontroller-operator` | `metacontroller-operator` | Kubernetes metacontroller |

## Intra-Component Relations

Relations wired internally within this component:

- `dex-auth:dex-oidc-config ↔ oidc-gatekeeper:dex-oidc-config`
- `dex-auth:oidc-client ↔ oidc-gatekeeper:oidc-client`
- `mlmd:grpc ↔ envoy:grpc`
- `kubeflow-profiles:kubeflow-profiles ↔ kubeflow-dashboard:kubeflow-profiles`

## Requirements

- Terraform >= 1.6
- Juju provider >= 1.0.0

## Usage

```hcl
module "core" {
  source = "../../components/core"

  model_uuid = juju_model.kubeflow.uuid
  risk       = "stable"

  # Service mesh — provide one of ingress (istio) or service_mesh (ambient)
  ingress = {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  }
}
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `model_uuid` | `string` | required | UUID of the Juju model |
| `risk` | `string` | `"edge"` | Channel risk: `stable`, `candidate`, `beta`, or `edge` |
| `dex_auth` | `object` | `{}` | Configuration for `dex-auth` |
| `oidc_gatekeeper` | `object` | `{}` | Configuration for `oidc-gatekeeper` |
| `minio` | `object` | `{}` | Configuration for `minio` |
| `mlmd` | `object` | `{}` | Configuration for `mlmd` |
| `envoy` | `object` | `{}` | Configuration for `envoy` |
| `kubeflow_dashboard` | `object` | `{}` | Configuration for `kubeflow-dashboard` |
| `kubeflow_profiles` | `object` | `{}` | Configuration for `kubeflow-profiles` |
| `kubeflow_roles` | `object` | `{}` | Configuration for `kubeflow-roles` |
| `kubeflow_volumes` | `object` | `{}` | Configuration for `kubeflow-volumes` |
| `metacontroller_operator` | `object` | `{}` | Configuration for `metacontroller-operator` |

All application objects accept: `revision`, `units`, `trust`, `constraints`, `config`, `resources`.

### Service mesh inputs (mutually exclusive — provide one set)

**Istio (sidecar)**

| Name | Type | Default | Description |
|---|---|---|---|
| `ingress` | `object` | `null` | `istio-pilot:ingress` endpoint for core apps |
| `ingress_auth` | `object` | `null` | `istio-pilot:ingress-auth` endpoint for oidc-gatekeeper |

**Ambient**

| Name | Type | Default | Description |
|---|---|---|---|
| `service_mesh` | `object` | `null` | `istio-beacon-k8s:service-mesh` endpoint for all core apps |
| `istio_ingress_route` | `object` | `null` | `istio-ingress-k8s:istio-ingress-route` for dashboard, volumes, envoy |
| `istio_ingress_route_unauthenticated` | `object` | `null` | `istio-ingress-k8s:istio-ingress-route-unauthenticated` for dex-auth, oidc-gatekeeper |

All mesh input objects accept `{ kind = "endpoint"|"offer", name, endpoint }` or `{ kind = "offer", url }`.

## Outputs

### `components`

Map of deployed Juju application objects: `dex_auth`, `envoy`, `kubeflow_dashboard`, `kubeflow_profiles`, `kubeflow_roles`, `kubeflow_volumes`, `minio`, `mlmd`, `oidc_gatekeeper`.

### `provides`

| Key | Application | Endpoint | Consumed by |
|---|---|---|---|
| `kubeflow_dashboard_links` | `kubeflow-dashboard` | `links` | KFP UI and other sidebar apps |
| `minio_object_storage` | `minio` | `object-storage` | KFP API, profile controller, UI |
| `mlmd_grpc` | `mlmd` | `grpc` | KFP metadata-writer |
| `oidc_gatekeeper_forward_auth` | `oidc-gatekeeper` | `forward-auth` | ambient: `istio-ingress-k8s` |

### `requires`

Endpoints required from the service mesh component (all `null`-safe, only wired when the corresponding input variable is set).

**Istio:** `dex_auth_ingress`, `envoy_ingress`, `kubeflow_dashboard_ingress`, `kubeflow_volumes_ingress`, `oidc_gatekeeper_ingress`, `oidc_gatekeeper_ingress_auth`

**Ambient (service-mesh):** `dex_auth_service_mesh`, `minio_service_mesh`, `oidc_gatekeeper_service_mesh`, `kubeflow_dashboard_service_mesh`, `kubeflow_profiles_service_mesh`, `kubeflow_volumes_service_mesh`, `envoy_service_mesh`

**Ambient (istio-ingress-route):** `kubeflow_dashboard_istio_ingress_route`, `kubeflow_volumes_istio_ingress_route`, `envoy_istio_ingress_route`, `oidc_gatekeeper_istio_ingress_route_unauthenticated`, `dex_auth_istio_ingress_route_unauthenticated`

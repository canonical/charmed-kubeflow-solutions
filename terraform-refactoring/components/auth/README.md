# Auth Component Module

Terraform component module for deploying Kubeflow authentication services using Juju charms.

## Overview

This component deploys the authentication and authorization services required for Kubeflow:

| Application | Charm | Role |
|---|---|---|
| `dex-auth` | `dex-auth` | OpenID Connect identity provider |
| `oidc-gatekeeper` | `oidc-gatekeeper` | HTTP authorization gateway |

## Intra-Component Relations

Relations wired internally within this component:

- `dex-auth:dex-oidc-config ↔ oidc-gatekeeper:dex-oidc-config`
- `dex-auth:oidc-client ↔ oidc-gatekeeper:oidc-client`

## Requirements

- Terraform >= 1.6
- Juju provider >= 1.0.0

## Usage

```hcl
module "auth" {
  source = "../../components/auth"

  model_uuid = juju_model.kubeflow.uuid
  risk       = "stable"

  # Service mesh — provide one of ingress (istio) or service_mesh (ambient)
  ingress = {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress.name
    endpoint = module.istio[0].provides.istio_pilot_ingress.endpoint
  }
  ingress_auth = {
    kind     = "endpoint"
    name     = module.istio[0].provides.istio_pilot_ingress_auth.name
    endpoint = module.istio[0].provides.istio_pilot_ingress_auth.endpoint
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

All application objects accept: `revision`, `units`, `trust`, `constraints`, `config`, `resources`.

### Service mesh inputs (mutually exclusive — provide one set)

**Istio (sidecar)**

| Name | Type | Default | Description |
|---|---|---|---|
| `ingress` | `object` | `null` | `istio-pilot:ingress` endpoint for dex-auth and oidc-gatekeeper |
| `ingress_auth` | `object` | `null` | `istio-pilot:ingress-auth` endpoint for oidc-gatekeeper |

**Ambient**

| Name | Type | Default | Description |
|---|---|---|---|
| `service_mesh` | `object` | `null` | `istio-beacon-k8s:service-mesh` endpoint for dex-auth and oidc-gatekeeper |
| `istio_ingress_route_unauthenticated` | `object` | `null` | `istio-ingress-k8s:istio-ingress-route-unauthenticated` for dex-auth and oidc-gatekeeper |

All mesh input objects accept `{ kind = "endpoint"|"offer", name, endpoint }` or `{ kind = "offer", url }`.

## Outputs

### `components`

Map of deployed Juju application objects: `dex_auth`, `oidc_gatekeeper`.

### `provides`

| Key | Application | Endpoint | Consumed by |
|---|---|---|---|
| `oidc_gatekeeper_forward_auth` | `oidc-gatekeeper` | `forward-auth` | ambient: `istio-ingress-k8s` |

### `requires`

Endpoints required from the service mesh component (all `null`-safe, only wired when the corresponding input variable is set).

**Istio:** `dex_auth_ingress`, `oidc_gatekeeper_ingress`, `oidc_gatekeeper_ingress_auth`

**Ambient (service-mesh):** `dex_auth_service_mesh`, `oidc_gatekeeper_service_mesh`

**Ambient (istio-ingress-route):** `oidc_gatekeeper_istio_ingress_route_unauthenticated`, `dex_auth_istio_ingress_route_unauthenticated`

## Inputs

| Variable | Description |
|----------|-------------|
| `risk` | Charm channel risk (stable/candidate/beta/edge) |
| `model_uuid` | UUID of the Juju model |
| `dex_auth` | Configuration for dex-auth application |
| `oidc_gatekeeper` | Configuration for oidc-gatekeeper application |
| `ingress` | Ingress provider (istio sidecar mode) |
| `ingress_auth` | Ingress-auth provider for oidc-gatekeeper (istio sidecar mode) |
| `service_mesh` | Service mesh provider (istio ambient mode) |
| `istio_ingress_route_unauthenticated` | Unauthenticated ingress route (istio ambient mode) |

## Outputs

| Output | Description |
|--------|-------------|
| `components` | Map of deployed application resources |
| `provides` | Endpoints provided to other components (`oidc_gatekeeper_forward_auth`) |
| `requires` | Endpoints required from other components (ingress, service-mesh, etc.) |

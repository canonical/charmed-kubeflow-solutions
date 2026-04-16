# Ambient Component Module

Terraform component module for deploying Istio Ambient mesh on Kubernetes using Juju charms.

## Overview

This component deploys the Istio Ambient stack consisting of three coordinated charm applications:

| Application | Charm | Channel | Role |
|---|---|---|---|
| `istio-k8s` | `istio-k8s` | `2/<risk>` | Control plane and mesh configuration |
| `istio-ingress-k8s` | `istio-ingress-k8s` | `2/<risk>` | Ingress gateway for external traffic |
| `istio-beacon-k8s` | `istio-beacon-k8s` | `2/<risk>` | Ambient mesh waypoints and service mesh integration |

The three charms work together through native Kubernetes integration. The only intra-component Juju relation is `istio-ingress-config` between `istio-k8s` and `istio-ingress-k8s`.

## Requirements

- Terraform >= 1.6
- Juju provider >= 1.0.0
- Kubernetes cluster with CNI support for ambient mesh

## Usage

```hcl
module "ambient" {
  source = "../../components/ambient"

  model_uuid = juju_model.kubeflow.uuid
  risk       = "stable"

  istio_k8s = {
    revision = 42
  }
  istio_ingress_k8s = {
    revision = 35
  }
  istio_beacon_k8s = {
    revision = 28
  }
}
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `model_uuid` | `string` | required | UUID of the Juju model |
| `risk` | `string` | `"edge"` | Channel risk: `stable`, `candidate`, `beta`, or `edge` |
| `istio_k8s` | `object` | `{}` | Configuration for `istio-k8s` (revision, units, trust, constraints, resources) |
| `istio_k8s_platform` | `string` | `""` | Platform config for `istio-k8s` (e.g. `linux/amd64`) |
| `istio_ingress_k8s` | `object` | `{}` | Configuration for `istio-ingress-k8s` (revision, units, trust, constraints, config, resources) |
| `istio_beacon_k8s` | `object` | `{}` | Configuration for `istio-beacon-k8s` (revision, units, trust, constraints, config, resources) |

## Outputs

### `components`

Map of the deployed Juju application objects, keyed by `istio_k8s`, `istio_ingress_k8s`, `istio_beacon_k8s`.

### `provides`

Inter-component endpoints this module exposes to other components:

| Key | Application | Endpoint | Consumed by |
|---|---|---|---|
| `istio_ingress_k8s_gateway` | `istio-ingress-k8s` | `gateway` | — |
| `istio_ingress_k8s_istio_ingress_route` | `istio-ingress-k8s` | `istio-ingress-route` | core: dashboard, volumes, envoy |
| `istio_ingress_k8s_istio_ingress_route_unauthenticated` | `istio-ingress-k8s` | `istio-ingress-route-unauthenticated` | core: dex-auth, oidc-gatekeeper |
| `istio_beacon_k8s_service_mesh` | `istio-beacon-k8s` | `service-mesh` | All workloads requiring ambient mesh |

### `requires`

Inter-component endpoints this module requires from other components:

| Key | Application | Endpoint | Provided by |
|---|---|---|---|
| `istio_ingress_k8s_forward_auth` | `istio-ingress-k8s` | `forward-auth` | core: `oidc-gatekeeper` |

> **Note:** The `forward-auth` integration creates a circular dependency if passed through module variables (since `module.core` already consumes `module.ambient` outputs). It is wired as a direct `juju_integration` resource in the product's `integrations.tf`.

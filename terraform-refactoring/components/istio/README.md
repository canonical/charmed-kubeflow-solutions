# Istio Component Module

Terraform component module for deploying Istio service mesh (sidecar mode) on Kubernetes using Juju charms.

## Overview

This component deploys the Istio sidecar stack consisting of two coordinated charm applications:

| Application | Charm | Channel | Role |
|---|---|---|---|
| `istio-pilot` | `istio-pilot` | `1.28/<risk>` | Control plane, ingress proxy configuration |
| `istio-ingressgateway` | `istio-gateway` | `1.28/<risk>` | Ingress gateway for north-south traffic |

The two charms communicate via Kubernetes native integration. There are no intra-component Juju relations.

## Requirements

- Terraform >= 1.6
- Juju provider >= 1.0.0
- Kubernetes cluster with Juju deployed

## Usage

```hcl
module "istio" {
  source = "../../components/istio"

  model_uuid = juju_model.kubeflow.uuid
  risk       = "stable"

  istio_pilot = {
    revision = 42
  }
  istio_gateway = {
    revision = 43
    config   = { kind = "ingress" }
  }
}
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `model_uuid` | `string` | required | UUID of the Juju model |
| `risk` | `string` | `"edge"` | Channel risk: `stable`, `candidate`, `beta`, or `edge` |
| `istio_pilot` | `object` | `{}` | Configuration for `istio-pilot` (revision, units, trust, constraints, config, resources) |
| `istio_gateway` | `object` | `{}` | Configuration for `istio-ingressgateway` (revision, units, trust, constraints, config, resources) |

## Outputs

### `components`

Map of the deployed Juju application objects, keyed by `istio_pilot`, `istio_gateway`.

### `provides`

Inter-component endpoints this module exposes to other components:

| Key | Application | Endpoint | Consumed by |
|---|---|---|---|
| `istio_ingressgateway_gateway` | `istio-ingressgateway` | `gateway` | — |
| `istio_pilot_ingress` | `istio-pilot` | `ingress` | core: dex-auth, oidc-gatekeeper, kubeflow-dashboard, kubeflow-volumes, envoy |
| `istio_pilot_ingress_auth` | `istio-pilot` | `ingress-auth` | core: `oidc-gatekeeper` |

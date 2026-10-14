# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

locals {
  # use_old_istio_bases keeps the pre-26.04 dev/edge revisions (Istio 1.29) for
  # MicroK8s, where the 1.31-only features are not needed. istio-beacon-k8s has
  # no 24.04 dev/edge revision, so its old base is 22.04.
  istio_ingress_base = var.use_old_istio_bases ? "ubuntu@24.04" : "ubuntu@26.04"
  istio_beacon_base  = var.use_old_istio_bases ? "ubuntu@22.04" : "ubuntu@26.04"
}

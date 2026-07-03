# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# No in-component integrations:
# - Each gateway consumes the istio-k8s istio-ingress-config offer inside its
#   own charm module (see charms/istio-ingress-k8s/integrations.tf).
# - The beacon joins the Istio mesh natively, with no Juju relation to the
#   control plane.
# Cross-component wiring (forward-auth, request-auth, service-mesh, gateway
# routing) is performed by the consuming product via this component's outputs.

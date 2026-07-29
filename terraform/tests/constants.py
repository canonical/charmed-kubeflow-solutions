# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

"""Shared constants for the Terraform deployment tests."""

# External hostnames for the kubeflow-ambient-iam solution, shared between the
# Terraform variables (conftest) and the DNS/assertion logic (test_deployment).
UI_HOSTNAME = "ui.kubeflow.com"
M2M_HOSTNAME = "api.kubeflow.com"
AUTH_HOSTNAME = "auth.kubeflow.com"

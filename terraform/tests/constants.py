# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

"""Shared constants for the Terraform deployment tests."""

# External hostnames for the ambient-IAM solutions, shared between the
# Terraform variables (conftest) and the DNS/assertion logic (test_deployment).
KUBEFLOW_AUTH_HOSTNAME = "auth.kubeflow.com"
KUBEFLOW_M2M_HOSTNAME = "api.kubeflow.com"
KUBEFLOW_UI_HOSTNAME = "ui.kubeflow.com"
MLFLOW_AUTH_HOSTNAME = "auth.mlflow.com"
MLFLOW_M2M_HOSTNAME = "api.mlflow.com"
MLFLOW_UI_HOSTNAME = "ui.mlflow.com"

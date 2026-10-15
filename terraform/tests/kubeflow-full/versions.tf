# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

terraform {
  required_version = ">=1.6"

  required_providers {
    juju = {
      source  = "juju/juju"
      version = ">=1.1.1"
    }
  }
}

provider "juju" {
  controller_addresses = var.JUJU_CONTROLLER_IPS
  username             = var.JUJU_USERNAME
  password             = var.JUJU_PASSWORD
  ca_certificate       = base64decode(var.JUJU_CA_CERTIFICATE)
}

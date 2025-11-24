terraform {
  required_version = ">= 1.6"
  required_providers {
    juju = {
      source  = "juju/juju"
      version = ">=1.0.0"
    }
  }
}

provider "juju" {
  controller_addresses = var.juju_controller.endpoint
  username         	= var.juju_controller.username
  password         	= var.juju_controller.password
  ca_certificate   	= var.juju_controller.ca == "null" ? base64decode(var.juju_controller.ca) : null
}
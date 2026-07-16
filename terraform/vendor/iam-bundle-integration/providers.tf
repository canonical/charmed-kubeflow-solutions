terraform {
  required_providers {
    juju = {
      source = "juju/juju"
      # Vendored patch: upstream pins "~> 1.0.0" (1.0.x only), which conflicts
      # with the charmed-kubeflow-solutions refactoring (juju >= 1.1.1). Relaxed
      # to "~> 1.0" so this module composes in a single root with the rest of
      # the deployment on juju 1.x.
      version = "~> 1.0"
    }
  }

  required_version = ">= 1.6.6"
}

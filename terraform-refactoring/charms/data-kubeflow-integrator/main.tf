# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_application" "integrator" {
  name       = var.app_name
  model_uuid = var.model_uuid

  charm {
    name     = "data-kubeflow-integrator"
    channel  = var.channel
    revision = var.revision
  }

  config      = merge(
    var.mysql != null ? {
      mysql-database-name = var.mysql.database_name,
      mysql-extra-user-roles = var.mysql.extra_user_roles
    } : {},
    var.postgresql != null ? {
      postgresql-database-name = var.postgresql.database_name,
      postgresql-extra-user-roles = var.postgresql.extra_user_roles
    } : {},
    var.spark != null ? {
      spark-service-account =  var.spark.service_account
    } : {}
  )
  units       = 1
  trust       = true
}


resource "juju_integration" "mysql" {
  count = var.mysql != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.integrator.name
    endpoint = "mysql"
  }

  application {
    name      = var.mysql.kind == "endpoint" ? var.mysql.name : null
    endpoint  = var.mysql.kind == "endpoint" ? var.mysql.endpoint : null
    offer_url = var.mysql.kind == "offer" ? var.mysql.url : null
  }
}

resource "juju_integration" "postgresql" {
  count = var.postgresql != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.integrator.name
    endpoint = "postgresql"
  }

  application {
    name      = var.postgresql.kind == "endpoint" ? var.postgresql.name : null
    endpoint  = var.postgresql.kind == "endpoint" ? var.postgresql.endpoint : null
    offer_url = var.postgresql.kind == "offer" ? var.postgresql.url : null
  }
}

resource "juju_integration" "spark" {
  count = var.spark != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.integrator.name
    endpoint = "spark"
  }

  application {
    name      = var.spark.kind == "endpoint" ? var.spark.name : null
    endpoint  = var.spark.kind == "endpoint" ? var.spark.endpoint : null
    offer_url = var.spark.kind == "offer" ? var.spark.url : null
  }
}

locals {
  is_central_db_deployed = var.katib.db == "shared"

  is_katib_deployed = var.katib.enable == true || contains(var.components, "katib")
}
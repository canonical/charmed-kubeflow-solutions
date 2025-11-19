output "components" {
  value = local.components
}

output "provides" {
  description = "Map of all the provided endpoints"
  value = local.provides
}

output "requires" {
  description = "Map of the requirer endpoints"
  value = local.requires
}


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

output "offers" {
  description = "Offers"
  value = {
    for key, offer in zipmap(keys(local.offers_selection), values(juju_offer.offered_endpoints)):
    key => offer.url
  }
}


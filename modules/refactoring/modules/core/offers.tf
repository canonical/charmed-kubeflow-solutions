resource "juju_offer" "offered_endpoints" {
  for_each = local.offers
  application_name = each.key
  endpoints = [each.value]
  model_uuid = data.juju_model.kubeflow.uuid
}

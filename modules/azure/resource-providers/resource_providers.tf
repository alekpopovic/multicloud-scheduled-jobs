resource "azurerm_resource_provider_registration" "this" {
  for_each = var.create ? var.provider_namespaces : []

  name = each.value
}

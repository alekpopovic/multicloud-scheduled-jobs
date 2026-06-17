resource "azurerm_user_assigned_identity" "pool" {
  count = var.create_pool_identity ? 1 : 0

  name                = "${local.safe_name}-batch-pool-uami"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
}

resource "azurerm_role_assignment" "acr_pull" {
  count = var.create_pool_identity && var.acr_id != null ? 1 : 0

  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.pool[0].principal_id
}

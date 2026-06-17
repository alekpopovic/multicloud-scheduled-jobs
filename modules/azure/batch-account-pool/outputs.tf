output "storage_account_id" {
  description = "ID of the storage account linked to the Azure Batch account."
  value       = azurerm_storage_account.batch.id
}

output "storage_account_name" {
  description = "Name of the storage account linked to the Azure Batch account."
  value       = azurerm_storage_account.batch.name
}

output "batch_account_id" {
  description = "ID of the Azure Batch account."
  value       = azurerm_batch_account.this.id
}

output "batch_account_name" {
  description = "Name of the Azure Batch account."
  value       = azurerm_batch_account.this.name
}

output "batch_account_endpoint" {
  description = "Endpoint of the Azure Batch account."
  value       = azurerm_batch_account.this.account_endpoint
}

output "batch_pool_id" {
  description = "ID of the Azure Batch pool."
  value       = azurerm_batch_pool.this.id
}

output "batch_pool_name" {
  description = "Name of the Azure Batch pool."
  value       = azurerm_batch_pool.this.name
}

output "pool_identity_id" {
  description = "ID of the user-assigned managed identity attached to the pool, or null when disabled."
  value       = var.create_pool_identity ? azurerm_user_assigned_identity.pool[0].id : null
}

output "pool_identity_principal_id" {
  description = "Principal ID of the pool user-assigned managed identity, or null when disabled."
  value       = var.create_pool_identity ? azurerm_user_assigned_identity.pool[0].principal_id : null
}

output "pool_identity_client_id" {
  description = "Client ID of the pool user-assigned managed identity, or null when disabled."
  value       = var.create_pool_identity ? azurerm_user_assigned_identity.pool[0].client_id : null
}

output "resource_group_name" {
  description = "Azure resource group name."
  value       = var.resource_group_name
}

output "location" {
  description = "Azure region."
  value       = var.location
}

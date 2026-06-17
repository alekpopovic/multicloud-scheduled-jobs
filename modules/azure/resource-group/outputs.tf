output "resource_group_name" {
  description = "Azure resource group name."
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "Azure resource group ID."
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "Azure resource group location."
  value       = azurerm_resource_group.this.location
}

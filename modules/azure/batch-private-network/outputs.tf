output "virtual_network_id" {
  description = "ID of the Azure virtual network."
  value       = azurerm_virtual_network.this.id
}

output "virtual_network_name" {
  description = "Name of the Azure virtual network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_id" {
  description = "ID of the Azure Batch subnet."
  value       = azurerm_subnet.batch.id
}

output "subnet_name" {
  description = "Name of the Azure Batch subnet."
  value       = azurerm_subnet.batch.name
}

output "network_security_group_id" {
  description = "ID of the network security group when created."
  value       = var.create_network_security_group ? azurerm_network_security_group.batch[0].id : null
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway when created."
  value       = var.create_nat_gateway ? azurerm_nat_gateway.this[0].id : null
}

output "nat_public_ip_id" {
  description = "ID of the NAT Gateway public IP when created."
  value       = var.create_nat_gateway ? azurerm_public_ip.nat[0].id : null
}

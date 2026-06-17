output "resource_group_name" {
  description = "Azure resource group name."
  value       = module.resource_group.resource_group_name
}

output "virtual_network_name" {
  description = "Azure virtual network name."
  value       = module.network.virtual_network_name
}

output "subnet_id" {
  description = "Azure Batch subnet ID."
  value       = module.network.subnet_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID, or null when disabled."
  value       = module.network.nat_gateway_id
}

output "batch_account_name" {
  description = "Azure Batch account name."
  value       = module.scheduled_batch_job.batch_account_name
}

output "batch_pool_name" {
  description = "Azure Batch pool name."
  value       = module.scheduled_batch_job.batch_pool_name
}

output "logic_app_name" {
  description = "Logic App workflow name."
  value       = module.scheduled_batch_job.logic_app_name
}

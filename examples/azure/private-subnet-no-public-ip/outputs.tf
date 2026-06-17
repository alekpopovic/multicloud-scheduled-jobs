output "virtual_network_name" {
  description = "Azure virtual network name placeholder."
  value       = module.network.virtual_network_name
}

output "subnet_id" {
  description = "Azure subnet ID placeholder."
  value       = module.network.subnet_id
}

output "logic_app_workflow_id" {
  description = "Logic Apps workflow ID placeholder."
  value       = module.scheduled_batch_job.logic_app_workflow_id
}

output "batch_account_name" {
  description = "Azure Batch account name placeholder."
  value       = module.scheduled_batch_job.batch_account_name
}

output "batch_pool_id" {
  description = "Azure Batch pool ID placeholder."
  value       = module.scheduled_batch_job.batch_pool_id
}

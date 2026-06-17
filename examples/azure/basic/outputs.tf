output "resource_group_name" {
  description = "Azure resource group name."
  value       = module.resource_group.resource_group_name
}

output "storage_account_name" {
  description = "Azure storage account name."
  value       = module.scheduled_batch_job.storage_account_name
}

output "batch_account_name" {
  description = "Azure Batch account name."
  value       = module.scheduled_batch_job.batch_account_name
}

output "batch_account_endpoint" {
  description = "Azure Batch account endpoint."
  value       = module.scheduled_batch_job.batch_account_endpoint
}

output "batch_pool_name" {
  description = "Azure Batch pool name."
  value       = module.scheduled_batch_job.batch_pool_name
}

output "logic_app_name" {
  description = "Logic App workflow name."
  value       = module.scheduled_batch_job.logic_app_name
}

output "logic_app_id" {
  description = "Logic App workflow ID."
  value       = module.scheduled_batch_job.logic_app_id
}

output "logic_app_identity_principal_id" {
  description = "Logic App managed identity principal ID."
  value       = module.scheduled_batch_job.logic_app_identity_principal_id
}

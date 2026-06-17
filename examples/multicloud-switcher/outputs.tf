output "cloud_provider" {
  description = "Selected cloud provider."
  value       = module.scheduled_batch_job.cloud_provider
}

output "scheduler_identifier" {
  description = "Selected provider scheduler identifier."
  value       = module.scheduled_batch_job.scheduler_identifier
}

output "orchestrator_identifier" {
  description = "Selected provider orchestrator identifier."
  value       = module.scheduled_batch_job.orchestrator_identifier
}

output "batch_queue_or_runtime_identifier" {
  description = "AWS Batch queue ARN or GCP Batch runtime service account email."
  value       = module.scheduled_batch_job.batch_queue_or_runtime_identifier
}

output "aws_batch_compute_environment_arn" {
  description = "AWS Batch Fargate compute environment ARN, or null when GCP is selected."
  value       = module.scheduled_batch_job.aws_batch_compute_environment_arn
}

output "aws_batch_job_queue_arn" {
  description = "AWS Batch job queue ARN, or null when GCP is selected."
  value       = module.scheduled_batch_job.aws_batch_job_queue_arn
}

output "aws_batch_job_definition_arn" {
  description = "AWS Batch job definition ARN, or null when GCP is selected."
  value       = module.scheduled_batch_job.aws_batch_job_definition_arn
}

output "aws_state_machine_arn" {
  description = "AWS Step Functions state machine ARN, or null when GCP is selected."
  value       = module.scheduled_batch_job.aws_state_machine_arn
}

output "aws_scheduler_schedule_arn" {
  description = "AWS EventBridge Scheduler schedule ARN, or null when GCP is selected."
  value       = module.scheduled_batch_job.aws_scheduler_schedule_arn
}

output "aws_batch_log_group_name" {
  description = "AWS Batch CloudWatch log group name, or null when GCP is selected."
  value       = module.scheduled_batch_job.aws_batch_log_group_name
}

output "gcp_batch_runtime_service_account_email" {
  description = "GCP Batch runtime service account email, or null when AWS is selected."
  value       = module.scheduled_batch_job.gcp_batch_runtime_service_account_email
}

output "gcp_workflow_name" {
  description = "GCP Workflows workflow name, or null when AWS is selected."
  value       = module.scheduled_batch_job.gcp_workflow_name
}

output "gcp_workflow_id" {
  description = "GCP Workflows workflow ID, or null when AWS is selected."
  value       = module.scheduled_batch_job.gcp_workflow_id
}

output "gcp_scheduler_job_name" {
  description = "GCP Cloud Scheduler job name, or null when AWS is selected."
  value       = module.scheduled_batch_job.gcp_scheduler_job_name
}

output "gcp_scheduler_job_id" {
  description = "GCP Cloud Scheduler job ID, or null when AWS is selected."
  value       = module.scheduled_batch_job.gcp_scheduler_job_id
}

output "gcp_workflow_executions_uri" {
  description = "GCP Workflows executions URI, or null when AWS is selected."
  value       = module.scheduled_batch_job.gcp_workflow_executions_uri
}

output "azure_storage_account_name" {
  description = "Azure storage account name, or null when Azure is not selected."
  value       = module.scheduled_batch_job.azure_storage_account_name
}

output "azure_batch_account_name" {
  description = "Azure Batch account name, or null when Azure is not selected."
  value       = module.scheduled_batch_job.azure_batch_account_name
}

output "azure_batch_account_endpoint" {
  description = "Azure Batch account endpoint, or null when Azure is not selected."
  value       = module.scheduled_batch_job.azure_batch_account_endpoint
}

output "azure_batch_pool_name" {
  description = "Azure Batch pool name, or null when Azure is not selected."
  value       = module.scheduled_batch_job.azure_batch_pool_name
}

output "azure_logic_app_name" {
  description = "Azure Logic App workflow name, or null when Azure is not selected."
  value       = module.scheduled_batch_job.azure_logic_app_name
}

output "azure_logic_app_id" {
  description = "Azure Logic App workflow ID, or null when Azure is not selected."
  value       = module.scheduled_batch_job.azure_logic_app_id
}

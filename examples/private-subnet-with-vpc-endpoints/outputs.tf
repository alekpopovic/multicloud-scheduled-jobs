output "endpoint_ids" {
  description = "IDs of created VPC endpoints."
  value       = module.vpc_endpoints_fargate.endpoint_ids
}

output "job_queue_arn" {
  description = "ARN of the AWS Batch job queue."
  value       = module.scheduled_batch_job.job_queue_arn
}

output "job_definition_arn" {
  description = "ARN of the AWS Batch job definition."
  value       = module.scheduled_batch_job.job_definition_arn
}

output "state_machine_arn" {
  description = "ARN of the Step Functions state machine."
  value       = module.scheduled_batch_job.state_machine_arn
}

output "schedule_arn" {
  description = "ARN of the EventBridge Scheduler schedule."
  value       = module.scheduled_batch_job.schedule_arn
}

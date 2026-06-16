output "job_queue_arn" {
  description = "ARN of the AWS Batch job queue."
  value       = null
}

output "job_definition_arn" {
  description = "ARN of the AWS Batch job definition."
  value       = null
}

output "state_machine_arn" {
  description = "ARN of the Step Functions state machine."
  value       = null
}

output "schedule_arn" {
  description = "ARN of the EventBridge Scheduler schedule."
  value       = null
}

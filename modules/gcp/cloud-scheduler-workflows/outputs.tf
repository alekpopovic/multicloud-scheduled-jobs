output "scheduler_job_name" {
  description = "Cloud Scheduler job name."
  value       = google_cloud_scheduler_job.this.name
}

output "scheduler_job_id" {
  description = "Full Cloud Scheduler job resource ID."
  value       = google_cloud_scheduler_job.this.id
}

output "scheduler_service_account_email" {
  description = "Email of the service account used by Cloud Scheduler."
  value       = google_service_account.scheduler.email
}

output "workflow_executions_uri" {
  description = "Workflow executions API URI used by the HTTP target."
  value       = local.workflow_executions_uri
}

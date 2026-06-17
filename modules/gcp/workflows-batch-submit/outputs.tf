output "workflow_id" {
  description = "Full Workflow resource ID."
  value       = google_workflows_workflow.this.id
}

output "workflow_name" {
  description = "Workflow name."
  value       = google_workflows_workflow.this.name
}

output "workflow_region" {
  description = "Region where the Workflow is deployed."
  value       = google_workflows_workflow.this.region
}

output "workflow_service_account_email" {
  description = "Email of the service account used by Workflows."
  value       = google_service_account.workflow.email
}

output "workflow_service_account_id" {
  description = "Full resource ID of the service account used by Workflows."
  value       = google_service_account.workflow.id
}

output "batch_location" {
  description = "Cloud Batch location used by the Workflow."
  value       = local.batch_location
}

output "service_account_email" {
  description = "Email of the GCP Batch runtime service account."
  value       = google_service_account.batch_runtime.email
}

output "service_account_id" {
  description = "ID of the GCP Batch runtime service account."
  value       = google_service_account.batch_runtime.account_id
}

output "service_account_name" {
  description = "Resource name of the GCP Batch runtime service account."
  value       = google_service_account.batch_runtime.name
}

output "service_account_member" {
  description = "IAM member string for the GCP Batch runtime service account."
  value       = "serviceAccount:${google_service_account.batch_runtime.email}"
}

output "runtime_roles" {
  description = "IAM roles granted to the GCP Batch runtime service account."
  value       = local.roles
}

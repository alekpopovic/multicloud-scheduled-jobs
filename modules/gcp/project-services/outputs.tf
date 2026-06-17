output "project_id" {
  description = "GCP project ID where APIs are managed."
  value       = var.project_id
}

output "enabled_services" {
  description = "Google APIs enabled by this module."
  value       = keys(google_project_service.enabled)
}

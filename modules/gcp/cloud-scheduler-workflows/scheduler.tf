resource "google_cloud_scheduler_job" "this" {
  project          = var.project_id
  region           = var.region
  name             = local.scheduler_name
  description      = "Triggers ${var.workflow_name} workflow"
  schedule         = var.schedule
  time_zone        = var.time_zone
  paused           = var.paused
  attempt_deadline = var.attempt_deadline

  retry_config {
    retry_count          = var.retry_count
    max_retry_duration   = var.max_retry_duration
    min_backoff_duration = var.min_backoff_duration
    max_backoff_duration = var.max_backoff_duration
  }

  http_target {
    http_method = "POST"
    uri         = local.workflow_executions_uri
    body = base64encode(jsonencode({
      argument = jsonencode(var.workflow_argument)
    }))

    headers = {
      Content-Type = "application/octet-stream"
      User-Agent   = "Google-Cloud-Scheduler"
    }

    oauth_token {
      service_account_email = google_service_account.scheduler.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }

  depends_on = [
    google_project_iam_member.scheduler_workflows_invoker,
  ]
}

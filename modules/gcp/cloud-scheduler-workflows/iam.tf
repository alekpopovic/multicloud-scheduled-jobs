resource "google_service_account" "scheduler" {
  project      = var.project_id
  account_id   = local.scheduler_sa_account_id
  display_name = "${var.name} Scheduler SA"
}

resource "google_project_iam_member" "scheduler_workflows_invoker" {
  project = var.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.scheduler.email}"
}

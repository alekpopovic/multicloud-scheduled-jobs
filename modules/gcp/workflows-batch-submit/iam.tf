resource "google_service_account" "workflow" {
  project      = var.project_id
  account_id   = local.workflow_sa_account_id
  display_name = "${var.name} Workflows SA"
}

resource "google_project_iam_member" "workflow_batch_jobs_editor" {
  project = var.project_id
  role    = "roles/batch.jobsEditor"
  member  = "serviceAccount:${google_service_account.workflow.email}"
}

resource "google_project_iam_member" "workflow_logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.workflow.email}"
}

resource "google_service_account_iam_member" "workflow_can_act_as_batch_runtime" {
  service_account_id = var.batch_service_account_id
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.workflow.email}"
}

resource "google_service_account" "batch_runtime" {
  project      = var.project_id
  account_id   = local.account_id
  display_name = "${var.name} Batch Runtime"
  description  = var.description
}

resource "google_project_iam_member" "runtime_roles" {
  for_each = local.roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.batch_runtime.email}"
}

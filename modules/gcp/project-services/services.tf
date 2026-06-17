resource "google_project_service" "enabled" {
  for_each = var.create ? var.services : []

  project            = var.project_id
  service            = each.value
  disable_on_destroy = var.disable_on_destroy
}

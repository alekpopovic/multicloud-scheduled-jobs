locals {
  batch_location = var.batch_location != null ? var.batch_location : var.region
  workflow_name  = "${var.name}-workflow"

  workflow_sa_base       = trim(replace(lower("${var.name}-wf-sa"), "/[^a-z0-9-]/", "-"), "-")
  workflow_sa_suffix     = local.workflow_sa_base != "" ? local.workflow_sa_base : "workflow"
  workflow_sa_account_id = trim(substr("wf-${local.workflow_sa_suffix}", 0, 30), "-")

  job_id_base   = trim(replace(lower(var.name), "/[^a-z0-9-]/", "-"), "-")
  job_id_suffix = local.job_id_base != "" ? local.job_id_base : "batch-job"
  job_id_prefix = trim(substr("batch-${local.job_id_suffix}", 0, 40), "-")

  labels = merge(var.workflow_labels, {
    managed_by = "terraform"
    module     = "workflows-batch-submit"
  })
}

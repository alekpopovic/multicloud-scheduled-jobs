locals {
  scheduler_name = "${var.name}-schedule"

  scheduler_sa_base       = trim(replace(lower("${var.name}-sched-sa"), "/[^a-z0-9-]/", "-"), "-")
  scheduler_sa_suffix     = local.scheduler_sa_base != "" ? local.scheduler_sa_base : "scheduler"
  scheduler_sa_account_id = trim(substr("sched-${local.scheduler_sa_suffix}", 0, 30), "-")

  workflow_executions_uri = "https://workflowexecutions.googleapis.com/v1/projects/${var.project_id}/locations/${var.workflow_region}/workflows/${var.workflow_name}/executions"
}

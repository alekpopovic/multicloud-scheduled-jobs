resource "google_workflows_workflow" "this" {
  project             = var.project_id
  name                = local.workflow_name
  region              = var.region
  service_account     = google_service_account.workflow.id
  deletion_protection = var.workflow_deletion_protection
  call_log_level      = var.call_log_level
  labels              = local.labels

  source_contents = templatefile("${path.module}/workflow.yaml.tftpl", {
    batch_labels_json                 = jsonencode(var.batch_labels)
    batch_location                    = local.batch_location
    batch_service_account_email       = var.batch_service_account_email
    container_commands_json           = jsonencode(var.container_commands)
    container_image                   = var.container_image
    cpu_milli                         = var.cpu_milli
    delete_job_on_completion          = var.delete_job_on_completion
    enable_command_override_from_args = var.enable_command_override_from_args
    environment_variables_json        = jsonencode(var.environment_variables)
    job_id_prefix                     = local.job_id_prefix
    machine_type                      = var.machine_type
    max_retry_count                   = var.max_retry_count
    max_run_duration                  = var.max_run_duration
    memory_mib                        = var.memory_mib
    network                           = var.network
    no_external_ip_address            = var.no_external_ip_address
    parallelism                       = var.parallelism
    provisioning_model                = var.provisioning_model
    subnetwork                        = var.subnetwork
    task_count                        = var.task_count
  })

  depends_on = [
    google_project_iam_member.workflow_batch_jobs_editor,
    google_project_iam_member.workflow_logging_writer,
    google_service_account_iam_member.workflow_can_act_as_batch_runtime,
  ]
}

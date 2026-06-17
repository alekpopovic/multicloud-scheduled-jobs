variable "cloud_provider" {
  description = "Cloud provider to use. Supported values are aws, gcp, and azure."
  type        = string
  default     = "aws"

  validation {
    condition     = contains(["aws", "gcp", "azure"], var.cloud_provider)
    error_message = "cloud_provider must be aws, gcp, or azure."
  }
}

variable "name" {
  description = "Name prefix for the scheduled batch job."
  type        = string
  default     = "scheduled-batch-multicloud"
}

variable "container_image" {
  description = "Container image used by the selected provider implementation."
  type        = string
}

variable "container_command" {
  description = "Container command used by the selected provider implementation."
  type        = list(string)
  default     = ["sh", "-c", "echo Hello from multicloud scheduled batch; date; env"]
}

variable "environment_variables" {
  description = "Environment variables passed to the container job."
  type        = map(string)
  default     = {}
}

variable "schedule_expression" {
  description = "Provider-specific schedule expression. AWS uses EventBridge syntax; GCP uses unix cron syntax."
  type        = string
  default     = null
}

variable "schedule_timezone" {
  description = "Timezone used to evaluate the schedule."
  type        = string
  default     = "Europe/Belgrade"
}

variable "tags" {
  description = "AWS tags. For GCP, these are converted to lowercase labels by the module."
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS region used by the AWS provider."
  type        = string
  default     = "eu-central-1"
}

variable "aws_config" {
  description = "AWS-specific configuration used when cloud_provider is aws."
  type = object({
    vpc_id                = optional(string)
    subnet_ids            = optional(list(string), [])
    assign_public_ip      = optional(bool, false)
    max_vcpus             = optional(number, 4)
    job_vcpu              = optional(string, "0.25")
    job_memory            = optional(string, "512")
    log_retention_in_days = optional(number, 14)
    schedule_group_name   = optional(string, "default")
  })
  default = {}
}

variable "gcp_config" {
  description = "GCP-specific configuration used when cloud_provider is gcp."
  type = object({
    project_id               = optional(string)
    region                   = optional(string, "europe-west1")
    scheduler_region         = optional(string)
    task_count               = optional(number, 1)
    parallelism              = optional(number, 1)
    cpu_milli                = optional(number, 1000)
    memory_mib               = optional(number, 512)
    max_retry_count          = optional(number, 0)
    max_run_duration         = optional(string, "3600s")
    machine_type             = optional(string, "e2-standard-2")
    provisioning_model       = optional(string, "STANDARD")
    network                  = optional(string)
    subnetwork               = optional(string)
    no_external_ip_address   = optional(bool, false)
    delete_job_on_completion = optional(bool, false)
    runtime_roles = optional(set(string), [
      "roles/logging.logWriter",
      "roles/artifactregistry.reader"
    ])
    additional_runtime_roles = optional(set(string), [])
  })
  default = {}
}

variable "azure_config" {
  description = "Azure-specific configuration used when cloud_provider is azure."
  type = object({
    subscription_id                  = optional(string)
    resource_group_name              = optional(string)
    location                         = optional(string, "westeurope")
    storage_account_name             = optional(string)
    batch_account_name               = optional(string)
    pool_name                        = optional(string)
    vm_size                          = optional(string, "STANDARD_D2S_V3")
    node_agent_sku_id                = optional(string, "batch.node.ubuntu 20.04")
    target_dedicated_nodes           = optional(number, 0)
    target_low_priority_nodes        = optional(number, 1)
    max_tasks_per_node               = optional(number, 1)
    container_command_line           = optional(string)
    preload_container_image          = optional(bool, true)
    create_pool_identity             = optional(bool, true)
    acr_id                           = optional(string)
    subnet_id                        = optional(string)
    public_address_provisioning_type = optional(string, "BatchManaged")
    recurrence_frequency             = optional(string, "Day")
    recurrence_interval              = optional(number, 1)
    recurrence_time_zone             = optional(string, "Central Europe Standard Time")
    recurrence_hours                 = optional(list(number), [3])
    recurrence_minutes               = optional(list(number), [0])
    recurrence_week_days             = optional(list(string), [])
    start_time                       = optional(string)
    task_max_wall_clock_time         = optional(string, "PT1H")
    task_retention_time              = optional(string, "P1D")
    task_retry_maximum               = optional(number, 0)
    poll_interval_seconds            = optional(number, 30)
    max_poll_attempts                = optional(number, 120)
    delete_job_on_completion         = optional(bool, false)
    terminate_job_on_task_failure    = optional(bool, true)
    batch_role_definition_name       = optional(string, "Azure Batch Job Submitter")
  })
  default = {}
}

variable "scheduler_input" {
  description = "JSON-serializable scheduler input passed to the selected provider implementation."
  type        = any
  default     = {}
}

variable "enable_command_override_from_scheduler_input" {
  description = "Whether scheduler input can override the container command."
  type        = bool
  default     = false
}

variable "project_id" {
  description = "GCP project ID where Workflows will be created."
  type        = string
}

variable "name" {
  description = "Name prefix for the Workflow."
  type        = string
}

variable "region" {
  description = "GCP region for Workflows and Batch jobs."
  type        = string
}

variable "batch_location" {
  description = "Google Cloud Batch location. Defaults to region when null."
  type        = string
  default     = null
}

variable "container_image" {
  description = "Container image URI used by the Cloud Batch job."
  type        = string
}

variable "container_commands" {
  description = "Default container command list used by the Cloud Batch job."
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Environment variables passed to the Batch runnable."
  type        = map(string)
  default     = {}
}

variable "task_count" {
  description = "Number of Batch tasks to run."
  type        = number
  default     = 1
}

variable "parallelism" {
  description = "Maximum number of tasks to run in parallel."
  type        = number
  default     = 1
}

variable "cpu_milli" {
  description = "CPU request in milli CPU units."
  type        = number
  default     = 1000
}

variable "memory_mib" {
  description = "Memory request in MiB."
  type        = number
  default     = 512
}

variable "max_retry_count" {
  description = "Maximum retry count for the Batch task."
  type        = number
  default     = 0
}

variable "max_run_duration" {
  description = "Maximum task run duration, for example 3600s."
  type        = string
  default     = "3600s"
}

variable "machine_type" {
  description = "Compute Engine machine type used by Batch."
  type        = string
  default     = "e2-standard-2"
}

variable "provisioning_model" {
  description = "Provisioning model for Batch VMs."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "SPOT"], var.provisioning_model)
    error_message = "provisioning_model must be STANDARD or SPOT."
  }
}

variable "batch_service_account_email" {
  description = "Service account email used by Cloud Batch runtime VMs."
  type        = string
}

variable "batch_service_account_id" {
  description = "Full service account resource ID used for the roles/iam.serviceAccountUser binding."
  type        = string
}

variable "network" {
  description = "Optional VPC network self link or resource name for Batch jobs."
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "Optional subnetwork self link or resource name for Batch jobs."
  type        = string
  default     = null
}

variable "no_external_ip_address" {
  description = "Whether Batch VMs should run without external IP addresses."
  type        = bool
  default     = false
}

variable "delete_job_on_completion" {
  description = "Whether the workflow deletes the Batch job after a successful create call returns."
  type        = bool
  default     = false
}

variable "workflow_deletion_protection" {
  description = "Whether deletion protection is enabled on the Workflow."
  type        = bool
  default     = false
}

variable "call_log_level" {
  description = "Workflows call logging level."
  type        = string
  default     = "LOG_ERRORS_ONLY"

  validation {
    condition     = contains(["LOG_ALL_CALLS", "LOG_ERRORS_ONLY", "LOG_NONE"], var.call_log_level)
    error_message = "call_log_level must be LOG_ALL_CALLS, LOG_ERRORS_ONLY, or LOG_NONE."
  }
}

variable "workflow_labels" {
  description = "Labels applied to the Workflow."
  type        = map(string)
  default     = {}
}

variable "batch_labels" {
  description = "Labels applied to Batch jobs created by the Workflow."
  type        = map(string)
  default     = {}
}

variable "enable_command_override_from_args" {
  description = "When true, workflow args.command overrides the default container command."
  type        = bool
  default     = false
}

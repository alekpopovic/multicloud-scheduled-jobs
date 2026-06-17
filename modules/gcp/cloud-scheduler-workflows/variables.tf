variable "project_id" {
  description = "GCP project ID where Cloud Scheduler will be created."
  type        = string
}

variable "name" {
  description = "Name prefix for the Cloud Scheduler job."
  type        = string
}

variable "region" {
  description = "Cloud Scheduler region."
  type        = string
}

variable "workflow_name" {
  description = "Name of the target Google Workflows workflow."
  type        = string
}

variable "workflow_region" {
  description = "Region of the target Google Workflows workflow."
  type        = string
}

variable "schedule" {
  description = "Cloud Scheduler cron schedule."
  type        = string
  default     = "0 3 * * *"
}

variable "time_zone" {
  description = "Time zone used by Cloud Scheduler."
  type        = string
  default     = "Europe/Belgrade"
}

variable "workflow_argument" {
  description = "Object passed to the Workflows execution argument field."
  type        = any
  default = {
    source = "cloud-scheduler"
  }
}

variable "retry_count" {
  description = "Maximum retry attempts for failed Scheduler HTTP target calls."
  type        = number
  default     = 2
}

variable "max_retry_duration" {
  description = "Maximum total retry duration."
  type        = string
  default     = "3600s"
}

variable "min_backoff_duration" {
  description = "Minimum backoff duration between retries."
  type        = string
  default     = "5s"
}

variable "max_backoff_duration" {
  description = "Maximum backoff duration between retries."
  type        = string
  default     = "3600s"
}

variable "attempt_deadline" {
  description = "Deadline for each Scheduler HTTP attempt."
  type        = string
  default     = "1800s"
}

variable "paused" {
  description = "Whether the Cloud Scheduler job is paused."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels reserved for resources that support labels."
  type        = map(string)
  default     = {}
}

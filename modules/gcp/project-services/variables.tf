variable "project_id" {
  description = "GCP project ID where required APIs will be enabled."
  type        = string
}

variable "services" {
  description = "Google APIs to enable for the scheduled Batch job stack."
  type        = set(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "batch.googleapis.com",
    "workflows.googleapis.com",
    "workflowexecutions.googleapis.com",
    "cloudscheduler.googleapis.com",
    "logging.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

variable "disable_on_destroy" {
  description = "Whether to disable the APIs when this Terraform resource is destroyed."
  type        = bool
  default     = false
}

variable "create" {
  description = "Whether to enable the configured Google APIs."
  type        = bool
  default     = true
}

variable "project_id" {
  description = "GCP project ID where runtime IAM will be created."
  type        = string
}

variable "name" {
  description = "Name prefix for GCP Batch runtime IAM resources."
  type        = string
}

variable "description" {
  description = "Description for the GCP Batch runtime service account."
  type        = string
  default     = "Runtime service account for Google Cloud Batch jobs"
}

variable "runtime_roles" {
  description = "Base IAM roles granted to the GCP Batch runtime service account."
  type        = set(string)
  default = [
    "roles/logging.logWriter",
    "roles/artifactregistry.reader"
  ]
}

variable "additional_runtime_roles" {
  description = "Additional least-privilege IAM roles granted to the GCP Batch runtime service account."
  type        = set(string)
  default     = []
}

variable "labels" {
  description = "Labels applied to resources that support labels."
  type        = map(string)
  default     = {}
}

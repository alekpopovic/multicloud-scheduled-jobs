variable "project_id" {
  description = "GCP project ID where private networking resources are configured."
  type        = string
}

variable "region" {
  description = "GCP region for the subnet and optional Cloud NAT."
  type        = string
}

variable "name" {
  description = "Name prefix for network resources."
  type        = string
}

variable "ip_cidr_range" {
  description = "Primary IPv4 CIDR range for the Batch subnet."
  type        = string
  default     = "10.10.0.0/24"
}

variable "create_cloud_nat" {
  description = "Whether to create Cloud Router and Cloud NAT for private egress."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Labels reserved for resources that support labels."
  type        = map(string)
  default     = {}
}

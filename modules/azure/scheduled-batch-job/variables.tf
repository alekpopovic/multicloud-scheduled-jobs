variable "name" {
  description = "Name prefix for the scheduled Azure Batch job flow."
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name."
  type        = string
}

variable "location" {
  description = "Azure region for the scheduled Azure Batch job flow."
  type        = string
}

variable "container_image" {
  description = "Container image used by Azure Batch tasks."
  type        = string
}

variable "tags" {
  description = "Tags applied to Azure resources that support tags."
  type        = map(string)
  default     = {}
}

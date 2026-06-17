variable "name" {
  description = "Name prefix for Azure Batch account and pool resources."
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name."
  type        = string
}

variable "location" {
  description = "Azure region for Azure Batch resources."
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

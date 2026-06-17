variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "location" {
  description = "Azure region for the example resources."
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Resource group name created by this example."
  type        = string
  default     = "rg-scheduled-batch-azure-basic"
}

variable "name" {
  description = "Name prefix for Azure Batch and Logic App resources."
  type        = string
  default     = "scheduled-batch-azure-basic"
}

variable "container_image" {
  description = "Container image used by Azure Batch tasks."
  type        = string
  default     = "mcr.microsoft.com/azure-cli:latest"
}

variable "container_command_line" {
  description = "Command line used by the Azure Batch task."
  type        = string
  default     = "/bin/sh -c \"echo Hello from Azure Batch; date; env\""
}

variable "tags" {
  description = "Tags applied to Azure resources."
  type        = map(string)
  default     = {}
}

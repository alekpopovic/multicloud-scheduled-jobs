variable "subscription_id" {
  description = "Azure subscription ID used by the azurerm provider."
  type        = string
}

variable "location" {
  description = "Azure region for the example."
  type        = string
  default     = "westeurope"
}

variable "name" {
  description = "Name prefix for the Azure scheduled Batch job."
  type        = string
  default     = "scheduled-batch-azure-basic"
}

variable "resource_group_name" {
  description = "Azure resource group name."
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

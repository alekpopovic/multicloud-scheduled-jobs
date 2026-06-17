variable "name" {
  description = "Name prefix for the Logic Apps workflow."
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name."
  type        = string
}

variable "location" {
  description = "Azure region for Logic Apps resources."
  type        = string
}

variable "batch_account_name" {
  description = "Azure Batch account name targeted by the workflow."
  type        = string
}

variable "batch_pool_id" {
  description = "Azure Batch pool ID targeted by the workflow."
  type        = string
}

variable "schedule_recurrence" {
  description = "Recurrence settings for the Logic Apps trigger in a later implementation."
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags applied to Azure resources that support tags."
  type        = map(string)
  default     = {}
}

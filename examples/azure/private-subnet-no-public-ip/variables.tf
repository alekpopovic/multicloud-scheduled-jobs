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
  description = "Name prefix for the Azure private scheduled Batch job."
  type        = string
  default     = "scheduled-batch-azure-private"
}

variable "resource_group_name" {
  description = "Azure resource group name."
  type        = string
}

variable "container_image" {
  description = "Container image used by Azure Batch tasks."
  type        = string
}

variable "address_space" {
  description = "Virtual network address space."
  type        = list(string)
  default     = ["10.30.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Subnet address prefixes for Azure Batch pool nodes."
  type        = list(string)
  default     = ["10.30.1.0/24"]
}

variable "tags" {
  description = "Tags applied to Azure resources that support tags."
  type        = map(string)
  default     = {}
}

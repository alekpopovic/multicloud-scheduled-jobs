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
  default     = "rg-scheduled-batch-azure-private"
}

variable "name" {
  description = "Name prefix for Azure resources."
  type        = string
  default     = "scheduled-batch-azure-private"
}

variable "container_image" {
  description = "Container image used by Azure Batch tasks."
  type        = string
  default     = "mcr.microsoft.com/azure-cli:latest"
}

variable "container_command_line" {
  description = "Command line used by the Azure Batch task."
  type        = string
  default     = "/bin/sh -c \"echo Hello from private Azure Batch; date; env\""
}

variable "address_space" {
  description = "VNet address space."
  type        = list(string)
  default     = ["10.40.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Subnet address prefixes for Azure Batch pool nodes."
  type        = list(string)
  default     = ["10.40.1.0/24"]
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway for outbound internet from no-public-IP Batch nodes."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to Azure resources."
  type        = map(string)
  default     = {}
}

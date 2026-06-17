variable "name" {
  description = "Name prefix for Azure private networking resources."
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name."
  type        = string
}

variable "location" {
  description = "Azure region for networking resources."
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

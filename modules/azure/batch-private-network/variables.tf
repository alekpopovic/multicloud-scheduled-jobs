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

variable "create_nat_gateway" {
  description = "Whether to create and associate a NAT Gateway for outbound internet access."
  type        = bool
  default     = false
}

variable "nat_gateway_idle_timeout_minutes" {
  description = "Idle timeout in minutes for the NAT Gateway."
  type        = number
  default     = 10
}

variable "service_endpoints" {
  description = "Service endpoints enabled on the Batch subnet."
  type        = list(string)
  default = [
    "Microsoft.Storage",
    "Microsoft.ContainerRegistry"
  ]
}

variable "create_network_security_group" {
  description = "Whether to create and associate a network security group with the Batch subnet."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to Azure resources that support tags."
  type        = map(string)
  default     = {}
}

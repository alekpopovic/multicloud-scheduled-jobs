variable "name" {
  description = "Azure resource group name."
  type        = string
}

variable "location" {
  description = "Azure region for the resource group."
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "Tags applied to Azure resources that support tags."
  type        = map(string)
  default     = {}
}

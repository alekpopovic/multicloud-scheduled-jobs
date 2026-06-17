variable "subscription_id" {
  description = "Optional Azure subscription ID. Authentication and subscription selection usually come from the azurerm provider configuration."
  type        = string
  default     = null
}

variable "provider_namespaces" {
  description = "Azure resource provider namespaces to register when create is true."
  type        = set(string)
  default = [
    "Microsoft.Batch",
    "Microsoft.Logic",
    "Microsoft.ManagedIdentity",
    "Microsoft.Network",
    "Microsoft.Storage",
    "Microsoft.Authorization",
    "Microsoft.Insights"
  ]
}

variable "create" {
  description = "Whether to register Azure resource providers. Defaults to false because many organizations do not allow Terraform to register providers."
  type        = bool
  default     = false
}

variable "resource_providers" {
  description = "Azure resource provider namespaces to register in a later implementation."
  type        = set(string)
  default = [
    "Microsoft.Batch",
    "Microsoft.Logic",
    "Microsoft.ManagedIdentity",
    "Microsoft.Network",
    "Microsoft.Storage"
  ]
}

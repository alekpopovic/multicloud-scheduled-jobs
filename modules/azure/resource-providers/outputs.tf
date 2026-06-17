output "registered_provider_namespaces" {
  description = "Azure resource provider namespaces managed by this module when create is true."
  value       = var.create ? keys(azurerm_resource_provider_registration.this) : []
}

locals {
  tags = merge(var.tags, {
    managed_by = "terraform"
    module     = "azure-resource-group"
  })
}

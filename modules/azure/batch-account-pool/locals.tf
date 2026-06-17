locals {
  tags = merge(var.tags, {
    managed_by = "terraform"
    module     = "batch-account-pool"
  })
}

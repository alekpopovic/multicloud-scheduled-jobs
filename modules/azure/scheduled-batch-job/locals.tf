locals {
  tags = merge(var.tags, {
    managed_by = "terraform"
    module     = "scheduled-batch-job"
  })
}

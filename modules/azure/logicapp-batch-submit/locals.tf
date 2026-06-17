locals {
  workflow_name = "${var.name}-logicapp"
  tags = merge(var.tags, {
    managed_by = "terraform"
    module     = "logicapp-batch-submit"
  })
}

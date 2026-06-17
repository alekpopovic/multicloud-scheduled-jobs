locals {
  virtual_network_name = "${var.name}-vnet"
  subnet_name          = "${var.name}-batch-subnet"
  tags = merge(var.tags, {
    managed_by = "terraform"
    module     = "batch-private-network"
  })
}

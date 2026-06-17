locals {
  vnet_name          = "${var.name}-vnet"
  subnet_name        = "${var.name}-batch-subnet"
  nsg_name           = "${var.name}-batch-nsg"
  nat_public_ip_name = "${var.name}-nat-pip"
  nat_gateway_name   = "${var.name}-natgw"

  tags = merge(var.tags, {
    managed_by = "terraform"
    module     = "azure-batch-private-network"
  })
}

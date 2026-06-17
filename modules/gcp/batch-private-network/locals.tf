locals {
  network_name = "${var.name}-vpc"
  subnet_name  = "${var.name}-subnet"
  router_name  = "${var.name}-router"
  nat_name     = "${var.name}-nat"
}

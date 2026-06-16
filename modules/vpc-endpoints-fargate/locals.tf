data "aws_partition" "current" {}
data "aws_region" "current" {}

locals {
  name = var.name
}

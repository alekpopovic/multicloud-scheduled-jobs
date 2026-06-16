data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  name = var.name
}

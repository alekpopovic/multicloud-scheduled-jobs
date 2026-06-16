data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name          = var.name
  schedule_name = "${var.name}-schedule"
  schedule_arn  = "arn:${data.aws_partition.current.partition}:scheduler:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:schedule/${var.schedule_group_name}/${local.schedule_name}"

  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "eventbridge-scheduler-sfn"
  })
}

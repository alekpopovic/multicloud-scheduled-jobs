data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  name                 = var.name
  batch_submit_job_arn = "arn:${data.aws_partition.current.partition}:states:::batch:submitJob.sync"
}

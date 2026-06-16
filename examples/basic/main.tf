provider "aws" {
  region = var.aws_region
}

module "scheduled_batch_job" {
  source = "../../modules/scheduled-batch-job"

  name                = var.name
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  container_image     = var.container_image
  assign_public_ip    = var.assign_public_ip
  schedule_expression = var.schedule_expression
  schedule_timezone   = var.schedule_timezone

  environment_variables = {
    APP_ENV   = "dev"
    LOG_LEVEL = "info"
  }

  tags = var.tags
}

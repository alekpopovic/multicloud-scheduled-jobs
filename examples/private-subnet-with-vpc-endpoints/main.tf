module "vpc_endpoints_fargate" {
  source = "../../modules/vpc-endpoints-fargate"

  name               = var.name
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

module "scheduled_batch_job" {
  source = "../../modules/scheduled-batch-job"

  name                = var.name
  schedule_expression = var.schedule_expression
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  container_image     = var.container_image
}

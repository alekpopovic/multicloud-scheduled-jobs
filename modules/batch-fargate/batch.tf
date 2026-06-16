resource "aws_cloudwatch_log_group" "batch" {
  name              = "/aws/batch/${var.name}"
  retention_in_days = var.log_retention_in_days

  tags = local.tags
}

resource "aws_security_group" "batch" {
  name        = "${var.name}-batch-sg"
  description = "Security group for AWS Batch Fargate jobs."
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_batch_compute_environment" "fargate" {
  name         = "${var.name}-fargate-ce"
  type         = "MANAGED"
  state        = "ENABLED"
  service_role = aws_iam_role.batch_service.arn

  compute_resources {
    type               = "FARGATE"
    max_vcpus          = var.max_vcpus
    subnets            = var.subnet_ids
    security_group_ids = [aws_security_group.batch.id]
  }

  tags = local.tags

  depends_on = [
    aws_iam_role_policy_attachment.batch_service
  ]
}

resource "aws_batch_job_queue" "this" {
  name     = "${var.name}-queue"
  state    = "ENABLED"
  priority = 1

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.fargate.arn
  }

  tags = local.tags
}

resource "aws_batch_job_definition" "this" {
  name                  = "${var.name}-job-definition"
  type                  = "container"
  platform_capabilities = ["FARGATE"]

  container_properties = jsonencode({
    image            = var.container_image
    command          = var.container_command
    executionRoleArn = aws_iam_role.batch_execution.arn
    jobRoleArn       = aws_iam_role.batch_job.arn

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    networkConfiguration = {
      assignPublicIp = var.assign_public_ip ? "ENABLED" : "DISABLED"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = var.job_vcpu
      },
      {
        type  = "MEMORY"
        value = var.job_memory
      }
    ]

    environment = [
      for name, value in var.environment_variables : {
        name  = name
        value = value
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.batch.name
        awslogs-region        = data.aws_region.current.region
        awslogs-stream-prefix = "batch"
      }
    }
  })

  tags = local.tags
}

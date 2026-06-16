resource "aws_security_group" "endpoints" {
  count = var.create ? 1 : 0

  name        = "${var.name}-vpce-sg"
  description = "Security group for Fargate private subnet VPC endpoints."
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

resource "aws_vpc_security_group_ingress_rule" "endpoints_https" {
  for_each = var.create ? toset(var.allowed_security_group_ids) : toset([])

  security_group_id            = aws_security_group.endpoints[0].id
  referenced_security_group_id = each.value
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "Allow HTTPS access from Fargate task security group."

  tags = local.tags
}

resource "aws_vpc_endpoint" "ecr_api" {
  count = var.create ? 1 : 0

  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoints[0].id]

  tags = local.tags
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.create ? 1 : 0

  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoints[0].id]

  tags = local.tags
}

resource "aws_vpc_endpoint" "logs" {
  count = var.create ? 1 : 0

  service_name        = "com.amazonaws.${data.aws_region.current.region}.logs"
  vpc_endpoint_type   = "Interface"
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.endpoints[0].id]

  tags = local.tags
}

resource "aws_vpc_endpoint" "s3" {
  count = var.create ? 1 : 0

  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  vpc_id            = var.vpc_id
  route_table_ids   = var.route_table_ids

  tags = local.tags
}

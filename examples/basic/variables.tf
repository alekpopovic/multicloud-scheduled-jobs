variable "aws_region" {
  description = "AWS region for the example."
  type        = string
  default     = "eu-central-1"
}

variable "name" {
  description = "Name prefix for the scheduled AWS Batch job."
  type        = string
  default     = "scheduled-batch-basic"
}

variable "vpc_id" {
  description = "VPC ID where AWS Batch Fargate resources will run."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where AWS Batch Fargate jobs will run."
  type        = list(string)
}

variable "container_image" {
  description = "Container image used by the AWS Batch job definition."
  type        = string
}

variable "assign_public_ip" {
  description = "Whether AWS Batch Fargate jobs should receive a public IP address."
  type        = bool
  default     = false
}

variable "schedule_expression" {
  description = "EventBridge Scheduler expression."
  type        = string
  default     = "cron(0 3 * * ? *)"
}

variable "schedule_timezone" {
  description = "Timezone used to evaluate the schedule expression."
  type        = string
  default     = "Europe/Belgrade"
}

variable "tags" {
  description = "Tags applied to resources created by the wrapper module."
  type        = map(string)
  default     = {}
}

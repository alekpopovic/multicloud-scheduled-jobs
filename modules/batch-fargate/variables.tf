variable "name" {
  description = "Name prefix for AWS Batch Fargate resources."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where AWS Batch Fargate jobs will run."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs attached to AWS Batch Fargate jobs."
  type        = list(string)
}

variable "container_image" {
  description = "Container image used by the AWS Batch job definition."
  type        = string
}

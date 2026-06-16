variable "name" {
  description = "Name prefix for VPC endpoint resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where endpoints will be created."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for interface endpoints."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for interface endpoints."
  type        = list(string)
}

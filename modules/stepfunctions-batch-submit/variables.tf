variable "name" {
  description = "Name of the Step Functions state machine."
  type        = string
}

variable "job_queue_arn" {
  description = "ARN of the AWS Batch job queue."
  type        = string
}

variable "job_definition_arn" {
  description = "ARN of the AWS Batch job definition."
  type        = string
}

variable "job_name" {
  description = "Name to use when submitting AWS Batch jobs."
  type        = string
}

variable "name" {
  description = "Name of the EventBridge Scheduler schedule."
  type        = string
}

variable "schedule_expression" {
  description = "EventBridge Scheduler expression, for example rate(1 day) or cron(...)."
  type        = string
}

variable "state_machine_arn" {
  description = "ARN of the Step Functions state machine to invoke."
  type        = string
}

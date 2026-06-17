provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = try(var.gcp_config.project_id, null)
  region  = try(var.gcp_config.region, "europe-west1")
}

provider "azurerm" {
  features {}

  subscription_id = try(var.azure_config.subscription_id, null)
}

module "scheduled_batch_job" {
  source = "../../modules/multicloud/scheduled-batch-job"

  cloud_provider = var.cloud_provider

  name                  = var.name
  container_image       = var.container_image
  container_command     = var.container_command
  environment_variables = var.environment_variables

  schedule_expression = var.schedule_expression
  schedule_timezone   = var.schedule_timezone

  aws_config   = var.aws_config
  gcp_config   = var.gcp_config
  azure_config = var.azure_config

  scheduler_input                              = var.scheduler_input
  enable_command_override_from_scheduler_input = var.enable_command_override_from_scheduler_input

  tags = var.tags
}

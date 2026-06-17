provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

module "resource_group" {
  source = "../../../modules/azure/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "scheduled_batch_job" {
  source = "../../../modules/azure/scheduled-batch-job"

  subscription_id     = var.subscription_id
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location

  name                   = var.name
  container_image        = var.container_image
  container_command_line = var.container_command_line

  environment_variables = {
    APP_ENV   = "dev"
    LOG_LEVEL = "info"
  }

  target_dedicated_nodes    = 0
  target_low_priority_nodes = 1

  recurrence_frequency = "Day"
  recurrence_interval  = 1
  recurrence_time_zone = "Central Europe Standard Time"
  recurrence_hours     = [3]
  recurrence_minutes   = [0]

  tags = var.tags
}

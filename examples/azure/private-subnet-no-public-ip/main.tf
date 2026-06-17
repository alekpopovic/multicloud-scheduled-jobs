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

module "network" {
  source = "../../../modules/azure/batch-private-network"

  name                    = var.name
  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.location
  address_space           = var.address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  create_nat_gateway      = var.create_nat_gateway
  tags                    = var.tags
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
    APP_ENV   = "prod"
    LOG_LEVEL = "info"
  }

  subnet_id                        = module.network.subnet_id
  public_address_provisioning_type = "NoPublicIPAddresses"
  target_dedicated_nodes           = 0
  target_low_priority_nodes        = 1
  create_pool_identity             = true

  recurrence_frequency = "Day"
  recurrence_interval  = 1
  recurrence_time_zone = "Central Europe Standard Time"
  recurrence_hours     = [3]
  recurrence_minutes   = [0]

  tags = var.tags
}

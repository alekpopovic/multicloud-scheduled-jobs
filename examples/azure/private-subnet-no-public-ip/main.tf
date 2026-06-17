provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

module "network" {
  source = "../../../modules/azure/batch-private-network"

  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  address_space           = var.address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  tags                    = var.tags
}

module "scheduled_batch_job" {
  source = "../../../modules/azure/scheduled-batch-job"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  container_image     = var.container_image
  tags                = var.tags
}

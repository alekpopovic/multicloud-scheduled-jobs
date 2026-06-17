provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

module "scheduled_batch_job" {
  source = "../../../modules/azure/scheduled-batch-job"

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  container_image     = var.container_image
  tags                = var.tags
}

resource "terraform_data" "validate_network_configuration" {
  lifecycle {
    precondition {
      condition     = var.public_address_provisioning_type != "NoPublicIPAddresses" || var.subnet_id != null
      error_message = "public_address_provisioning_type = \"NoPublicIPAddresses\" requires subnet_id."
    }

    precondition {
      condition     = var.acr_id == null || var.create_pool_identity
      error_message = "acr_id requires create_pool_identity = true so AcrPull can be granted to the pool identity."
    }
  }
}

resource "azurerm_batch_account" "this" {
  name                                = local.batch_account_name
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  pool_allocation_mode                = var.pool_allocation_mode
  storage_account_id                  = azurerm_storage_account.batch.id
  storage_account_authentication_mode = "StorageKeys"
  tags                                = local.tags
}

resource "azurerm_batch_pool" "this" {
  name                     = local.pool_name
  resource_group_name      = var.resource_group_name
  account_name             = azurerm_batch_account.this.name
  display_name             = coalesce(var.pool_display_name, local.pool_name)
  vm_size                  = var.vm_size
  node_agent_sku_id        = var.node_agent_sku_id
  max_tasks_per_node       = var.max_tasks_per_node
  inter_node_communication = var.inter_node_communication

  fixed_scale {
    target_dedicated_nodes    = var.target_dedicated_nodes
    target_low_priority_nodes = var.target_low_priority_nodes
    resize_timeout            = var.resize_timeout
  }

  storage_image_reference {
    publisher = var.storage_image_reference.publisher
    offer     = var.storage_image_reference.offer
    sku       = var.storage_image_reference.sku
    version   = var.storage_image_reference.version
  }

  container_configuration {
    type                  = "DockerCompatible"
    container_image_names = var.preload_container_image ? [var.container_image] : []

    container_registries = var.acr_id != null && var.create_pool_identity ? [
      {
        registry_server           = local.acr_login_server
        user_assigned_identity_id = azurerm_user_assigned_identity.pool[0].id
        user_name                 = null
        password                  = null
      }
    ] : []
  }

  dynamic "identity" {
    for_each = var.create_pool_identity ? [1] : []

    content {
      type         = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.pool[0].id]
    }
  }

  network_configuration {
    subnet_id                        = var.subnet_id
    public_address_provisioning_type = var.public_address_provisioning_type
  }

  depends_on = [
    terraform_data.validate_network_configuration,
    azurerm_role_assignment.acr_pull,
  ]
}

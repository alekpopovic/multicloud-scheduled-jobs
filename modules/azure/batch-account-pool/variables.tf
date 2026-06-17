variable "name" {
  description = "Name prefix for Azure Batch account and pool resources."
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name."
  type        = string
}

variable "location" {
  description = "Azure region for Azure Batch resources."
  type        = string
}

variable "storage_account_name" {
  description = "Optional storage account name. When null, a unique lowercase name is generated."
  type        = string
  default     = null
}

variable "batch_account_name" {
  description = "Optional Azure Batch account name. When null, a unique lowercase name is generated."
  type        = string
  default     = null
}

variable "pool_name" {
  description = "Optional Azure Batch pool name. When null, a sanitized name-pool value is used."
  type        = string
  default     = null
}

variable "pool_display_name" {
  description = "Optional display name for the Azure Batch pool."
  type        = string
  default     = null
}

variable "vm_size" {
  description = "Azure VM size used by pool nodes."
  type        = string
  default     = "STANDARD_D2S_V3"
}

variable "node_agent_sku_id" {
  description = "Azure Batch node agent SKU ID."
  type        = string
  default     = "batch.node.ubuntu 20.04"
}

variable "storage_image_reference" {
  description = "Azure Marketplace image reference compatible with the selected Batch node agent SKU."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "microsoft-azure-batch"
    offer     = "ubuntu-server-container"
    sku       = "20-04-lts"
    version   = "latest"
  }
}

variable "target_dedicated_nodes" {
  description = "Target number of dedicated nodes in the Batch pool."
  type        = number
  default     = 0
}

variable "target_low_priority_nodes" {
  description = "Target number of low-priority nodes in the Batch pool."
  type        = number
  default     = 1
}

variable "resize_timeout" {
  description = "Timeout for Batch pool resize operations."
  type        = string
  default     = "PT15M"
}

variable "max_tasks_per_node" {
  description = "Maximum number of tasks that can run concurrently on one node."
  type        = number
  default     = 1
}

variable "inter_node_communication" {
  description = "Whether inter-node communication is enabled for the pool."
  type        = string
  default     = "Disabled"
}

variable "container_image" {
  description = "Container image used by Azure Batch tasks."
  type        = string
}

variable "preload_container_image" {
  description = "Whether the Batch pool should preload container_image on nodes."
  type        = bool
  default     = true
}

variable "create_pool_identity" {
  description = "Whether to create and attach a user-assigned managed identity to the Batch pool."
  type        = bool
  default     = true
}

variable "acr_id" {
  description = "Optional Azure Container Registry resource ID. When set with create_pool_identity, AcrPull is granted to the pool identity."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Optional subnet ID for Azure Batch pool network attachment."
  type        = string
  default     = null
}

variable "public_address_provisioning_type" {
  description = "Public IP provisioning mode for Azure Batch pool nodes."
  type        = string
  default     = "BatchManaged"

  validation {
    condition     = contains(["BatchManaged", "UserManaged", "NoPublicIPAddresses"], var.public_address_provisioning_type)
    error_message = "public_address_provisioning_type must be BatchManaged, UserManaged, or NoPublicIPAddresses."
  }
}

variable "pool_allocation_mode" {
  description = "Azure Batch pool allocation mode."
  type        = string
  default     = "BatchService"

  validation {
    condition     = contains(["BatchService", "UserSubscription"], var.pool_allocation_mode)
    error_message = "pool_allocation_mode must be BatchService or UserSubscription."
  }
}

variable "storage_account_replication_type" {
  description = "Replication type for the Batch linked storage account."
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags applied to Azure resources that support tags."
  type        = map(string)
  default     = {}
}

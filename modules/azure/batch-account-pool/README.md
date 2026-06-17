# batch-account-pool

Creates Azure Batch runtime infrastructure for container tasks:

- Storage account linked to the Batch account
- Azure Batch account
- Azure Batch pool with container support
- Optional user-assigned managed identity for the pool
- Optional `AcrPull` role assignment for a private Azure Container Registry
- Optional subnet attachment and public IP provisioning configuration

This module does not create Batch jobs or tasks. Logic Apps will create jobs and tasks at runtime through Azure Batch REST API calls.

## Batch Account, Pool, Jobs, And Tasks

The Batch account owns pools, jobs, and tasks. This module creates the account and pool only. The pool provides compute nodes that can run Docker-compatible container tasks.

Jobs and tasks are intentionally left out of Terraform so each Logic App execution can create runtime work with fresh inputs.

## Container Images

`container_image` is the image that Azure Batch tasks will run. When `preload_container_image = true`, the image is added to the pool `container_image_names` so Batch can pre-pull it on nodes.

The default pool image is the Microsoft Batch Ubuntu container-compatible image:

```hcl
storage_image_reference = {
  publisher = "microsoft-azure-batch"
  offer     = "ubuntu-server-container"
  sku       = "20-04-lts"
  version   = "latest"
}
```

This image is compatible with the default `node_agent_sku_id = "batch.node.ubuntu 20.04"`.

## Pool Identity And Private ACR

By default, the module creates a user-assigned managed identity and attaches it to the Batch pool.

When `acr_id` is set, the module grants `AcrPull` on that registry to the pool identity and configures the pool container registry entry to use managed identity. No registry passwords, service principal secrets, storage account keys, or Batch account keys are created or output.

## Public Address Provisioning

`public_address_provisioning_type` controls public IP behavior:

- `BatchManaged`: Azure Batch manages public IP addresses for pool nodes.
- `UserManaged`: user-managed public IPs are expected.
- `NoPublicIPAddresses`: pool nodes do not get public IPs.

When using `NoPublicIPAddresses`, `subnet_id` is required. Azure Batch no-public-IP support depends on region, pool allocation mode, subnet configuration, and outbound connectivity. Ensure the subnet has the required private egress path for image pulls and Azure Batch control plane communication.

## Basic Usage

```hcl
module "batch_account_pool" {
  source = "../batch-account-pool"

  name                = "scheduled-batch"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  container_image     = "mcr.microsoft.com/azure-cli:latest"
}
```

## Private ACR Usage

```hcl
module "batch_account_pool" {
  source = "../batch-account-pool"

  name                = "scheduled-batch"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  container_image     = "myregistry.azurecr.io/jobs/worker:latest"

  create_pool_identity = true
  acr_id               = azurerm_container_registry.this.id
}
```

## No-Public-IP Usage

```hcl
module "batch_account_pool" {
  source = "../batch-account-pool"

  name                = "scheduled-batch"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  container_image     = "myregistry.azurecr.io/jobs/worker:latest"

  subnet_id                         = module.private_network.subnet_id
  public_address_provisioning_type  = "NoPublicIPAddresses"
}
```

# batch-private-network

Optional helper module for Azure Batch pools that need subnet attachment or no-public-IP networking.

The module creates:

- Azure virtual network
- Azure subnet for Batch pool nodes
- Optional network security group without broad inbound rules
- Optional NAT Gateway for outbound internet access
- Optional service endpoints on the subnet

## When To Use This Module

Use this module when `modules/azure/batch-account-pool` should attach a pool to a subnet, especially when using:

```hcl
public_address_provisioning_type = "NoPublicIPAddresses"
```

Pass `subnet_id` from this module to the Batch account/pool module.

## NoPublicIPAddresses

`NoPublicIPAddresses` prevents Azure Batch pool nodes from receiving public IP addresses. This pattern has Azure Batch region, feature, networking, and simplified node communication requirements. Confirm support for your region and account mode before applying it in production.

## NAT Gateway

Set `create_nat_gateway = true` when Batch tasks need outbound internet access, for example to reach a public container registry, package repository, or third-party API.

If the task only talks to private endpoints or Azure services reachable through service endpoints/private networking, NAT Gateway may not be necessary.

## Service Endpoints

By default, the subnet enables:

- `Microsoft.Storage`
- `Microsoft.ContainerRegistry`

Service endpoints can help keep traffic to supported Azure services on the Azure backbone, but they are not a replacement for private endpoint and firewall planning.

For private Azure Container Registry, also plan:

- `AcrPull` for the Batch pool managed identity
- registry network rules or private endpoints
- storage/network access required by the registry and Batch pool nodes

## Usage

```hcl
module "private_network" {
  source = "../batch-private-network"

  name                = "scheduled-batch"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location

  create_nat_gateway = true
}

module "batch_account_pool" {
  source = "../batch-account-pool"

  name                              = "scheduled-batch"
  resource_group_name               = module.resource_group.resource_group_name
  location                          = module.resource_group.location
  container_image                   = var.container_image
  subnet_id                         = module.private_network.subnet_id
  public_address_provisioning_type  = "NoPublicIPAddresses"
}
```

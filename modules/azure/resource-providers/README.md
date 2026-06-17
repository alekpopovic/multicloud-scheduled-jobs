# resource-providers

Optional module for registering Azure Resource Provider namespaces required by the Azure Batch and Logic Apps flow.

The default is `create = false` because the `azurerm` provider can often auto-register providers, and many organizations do not allow Terraform to register resource providers.

## Usage

```hcl
module "resource_providers" {
  source = "../resource-providers"

  create = true
}
```

`subscription_id` is optional. In most cases, provider authentication and subscription selection come from the root `azurerm` provider configuration.

## Manual Registration

If Terraform is not allowed to register providers, use Azure CLI:

```bash
az provider register --namespace Microsoft.Batch
az provider register --namespace Microsoft.Logic
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.Network
az provider register --namespace Microsoft.Storage
```

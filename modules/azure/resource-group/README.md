# resource-group

Creates an Azure resource group for examples or higher-level wrapper modules.

The root repository does not create cloud resources directly. Examples and wrappers should use reusable modules such as this one.

## Usage

```hcl
module "resource_group" {
  source = "../resource-group"

  name     = "rg-scheduled-batch"
  location = "westeurope"

  tags = {
    project = "scheduled-batch"
    env     = "dev"
  }
}
```

## Tags

The module merges user-provided `tags` with:

```hcl
{
  managed_by = "terraform"
  module     = "azure-resource-group"
}
```

# Azure Private Subnet No Public IP Example

Skeleton example for a future Azure Batch private networking pattern.

Target flow:

```text
Azure Logic Apps Recurrence Trigger -> Azure Logic Apps Workflow -> Azure Batch REST API -> Azure Batch Pool -> Container Task
```

This example uses `modules/azure/batch-private-network` and `modules/azure/scheduled-batch-job`. Detailed private pool and no-public-IP implementation is deferred to later prompts.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
```

Do not put Azure credentials, service principal secrets, storage account keys, or Batch account keys in `tfvars`.

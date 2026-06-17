# Azure Basic Example

Skeleton example for the Azure scheduled Batch flow:

```text
Azure Logic Apps Recurrence Trigger -> Azure Logic Apps Workflow -> Azure Batch REST API -> Azure Batch Pool -> Container Task
```

This example uses `modules/azure/scheduled-batch-job` directly. Detailed Azure resource implementation is deferred to later prompts.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
```

Do not put Azure credentials, service principal secrets, storage account keys, or Batch account keys in `tfvars`.

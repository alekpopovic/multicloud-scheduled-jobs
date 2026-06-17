# scheduled-batch-job

Skeleton wrapper module for the Azure scheduled Batch flow:

```text
Azure Logic Apps Recurrence Trigger -> Azure Logic Apps Workflow -> Azure Batch REST API -> Azure Batch Pool -> Container Task
```

Future implementation will compose the Azure building-block modules. It must use managed identity where possible and must not create Azure Functions, Azure Container Apps Jobs, Kubernetes resources, client secrets, service principal secrets, storage account key outputs, or Batch account key outputs.

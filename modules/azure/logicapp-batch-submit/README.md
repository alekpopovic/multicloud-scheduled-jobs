# logicapp-batch-submit

Skeleton module for a Logic Apps workflow that submits Azure Batch container tasks.

Target Azure flow:

```text
Azure Logic Apps Recurrence Trigger -> Azure Logic Apps Workflow -> Azure Batch REST API -> Azure Batch Pool -> Container Task
```

Future implementation should use managed identity for Azure REST API calls and must not introduce Azure Functions, Azure Container Apps Jobs, Kubernetes, service principal secrets, or key-based authentication.

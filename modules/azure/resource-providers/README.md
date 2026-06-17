# resource-providers

Skeleton module for optional Azure resource provider registration.

Future implementation will register provider namespaces required by the Azure scheduled Batch flow:

```text
Logic Apps Recurrence Trigger -> Logic Apps Workflow -> Azure Batch REST API -> Azure Batch Pool -> Container Task
```

This module must not create credentials, service principal secrets, or hardcode subscription IDs.

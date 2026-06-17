# Azure Basic Example

This example creates a minimal Azure scheduled Batch flow:

```text
Logic Apps Recurrence Trigger -> Logic App Workflow -> Azure Batch REST API -> Azure Batch Pool -> Container Task
```

It creates a resource group, storage account, Azure Batch account, Batch pool, Logic App workflow, managed identities, and least-privilege role assignment for the Logic App to submit Batch work. It does not create secrets, service principal secrets, Batch shared keys, Azure Functions, or Azure Container Apps Jobs.

## Login

```bash
az login
az account set --subscription SUBSCRIPTION_ID
```

## Optional Provider Registration

Some subscriptions require explicit resource provider registration:

```bash
az provider register --namespace Microsoft.Batch
az provider register --namespace Microsoft.Logic
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.Storage
```

## Apply

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan
terraform apply
```

## Manual Test

Run the Logic App recurrence trigger manually:

```bash
az logic workflow run trigger \
  --resource-group "$(terraform output -raw resource_group_name)" \
  --name "$(terraform output -raw logic_app_name)" \
  --trigger-name Recurrence
```

List Azure Batch jobs:

```bash
az batch job list \
  --account-name "$(terraform output -raw batch_account_name)" \
  --account-endpoint "https://$(terraform output -raw batch_account_endpoint)"
```

The `az batch` CLI often needs an active Azure login and account context. Use `az account show` to confirm the selected subscription.

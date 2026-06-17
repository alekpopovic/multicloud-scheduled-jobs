# Azure Private Subnet No Public IP Example

This example creates the Azure scheduled Batch flow with a dedicated VNet/subnet and Batch pool nodes configured with `NoPublicIPAddresses`.

```text
Logic Apps Recurrence Trigger -> Logic App Workflow -> Azure Batch REST API -> Azure Batch Pool -> Container Task
```

The example creates:

- Resource group
- VNet and Batch subnet
- Optional NAT Gateway
- Azure Batch account and pool
- Logic App workflow with managed identity

## No Public IP

`public_address_provisioning_type = "NoPublicIPAddresses"` attaches Batch pool nodes to the subnet without public IP addresses. This depends on Azure Batch region support, account settings, and simplified node communication support.

NAT Gateway is enabled by default in this example because tasks often need outbound internet access to pull public container images or call external APIs.

## Private ACR

For private Azure Container Registry:

- Keep `create_pool_identity = true`.
- Set `acr_id` in the scheduled Batch module usage so the pool identity gets `AcrPull`.
- If ACR is network-restricted, also configure registry network access, private endpoints, DNS, or allowed network paths.

## Apply

```bash
az login
az account set --subscription SUBSCRIPTION_ID
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan
terraform apply
```

## Manual Test

```bash
az logic workflow run trigger \
  --resource-group "$(terraform output -raw resource_group_name)" \
  --name "$(terraform output -raw logic_app_name)" \
  --trigger-name Recurrence
```

```bash
az batch job list \
  --account-name "$(terraform output -raw batch_account_name)"
```

## Troubleshooting

Pool nodes unusable: check subnet capacity, Azure Batch regional support for no-public-IP pools, simplified node communication settings, and outbound connectivity.

Container image pull fails: enable NAT Gateway for public images, or configure ACR `AcrPull`, private endpoint/DNS, and registry network rules for private ACR.

Logic App permission denied: confirm the Logic App managed identity has the configured Batch submitter role assignment on the Batch account.

Batch task never completes: inspect Batch task stdout/stderr and confirm `task_max_wall_clock_time`, polling interval, and retry settings match the container runtime.

No-public-IP region/support issue: verify the selected Azure region and Batch account settings support `NoPublicIPAddresses` for the pool configuration.

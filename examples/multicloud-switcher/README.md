# Multicloud Switcher Example

This example shows how to choose AWS, GCP, or Azure with one variable:

```hcl
cloud_provider = "aws"
```

or:

```hcl
cloud_provider = "gcp"
```

or:

```hcl
cloud_provider = "azure"
```

It uses `modules/multicloud/scheduled-batch-job`, which has static AWS, GCP, and Azure module blocks and enables only the selected implementation with `count`.

The switcher example may install AWS, Google, and Azure provider plugins during `terraform init`, but it creates resources only for the selected `cloud_provider`.

## AWS Usage

```bash
cp aws.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan
terraform apply
```

AWS uses EventBridge Scheduler expressions, for example:

```hcl
schedule_expression = "cron(0 3 * * ? *)"
```

## GCP Usage

Enable the Service Usage API before managing project services with Terraform:

```bash
gcloud services enable serviceusage.googleapis.com --project PROJECT_ID
```

Then run:

```bash
cp gcp.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan
terraform apply
```

GCP uses unix cron format, for example:

```hcl
schedule_expression = "0 3 * * *"
```

## Azure Usage

Azure requires an existing resource group name in `azure_config.resource_group_name`, or you need to create that resource group separately before applying this example. The multicloud switcher does not create a resource group.

```bash
cp azure.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan
terraform apply
```

Azure Logic Apps uses recurrence configuration instead of the AWS/GCP `schedule_expression` string:

```hcl
azure_config = {
  recurrence_frequency = "Day"
  recurrence_interval  = 1
  recurrence_time_zone = "Central Europe Standard Time"
  recurrence_hours     = [3]
  recurrence_minutes   = [0]
}
```

Schedule configuration differs by provider:

- AWS `schedule_expression`: EventBridge cron/rate syntax, for example `cron(0 3 * * ? *)`.
- GCP `schedule_expression`: unix cron syntax, for example `0 3 * * *`.
- Azure `recurrence_*`: Logic Apps Recurrence fields such as frequency, interval, hours, minutes, and time zone.

## Authentication

Provider credentials come from the standard AWS, GCP, and Azure authentication mechanisms.

For AWS, use environment variables, shared config profiles, SSO, or instance/role credentials supported by the AWS provider.

For GCP, use Application Default Credentials, workload identity, or other credentials supported by the Google provider.

For Azure, use Azure CLI login, workload identity, managed identity, or other credentials supported by the AzureRM provider.

Do not put credentials or secrets in `*.tfvars` files.

## Inputs

Use `aws_config` when `cloud_provider = "aws"`. At minimum, provide:

- `vpc_id`
- `subnet_ids`

Use `gcp_config` when `cloud_provider = "gcp"`. At minimum, provide:

- `project_id`

Use `azure_config` when `cloud_provider = "azure"`. At minimum, provide:

- `subscription_id`
- `resource_group_name`

The same `container_image`, `container_command`, `environment_variables`, `scheduler_input`, and `tags` variables are passed through the multicloud switcher to the selected provider implementation.

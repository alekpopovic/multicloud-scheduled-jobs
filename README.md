# Multicloud Scheduled Jobs

## Overview

This repository contains reusable Terraform modules for scheduled batch workloads on:

- AWS
- Google Cloud
- Azure

The root directory does not create cloud resources directly. Cloud resources live in reusable modules under `modules/`, and runnable examples live under `examples/`.

## Architecture

AWS:

```text
EventBridge Scheduler
      |
      v
AWS Step Functions
      |
      v
AWS Batch SubmitJob
      |
      v
AWS Batch Job Queue
      |
      v
AWS Batch Fargate Compute Environment
      |
      v
Container Job
```

GCP:

```text
Cloud Scheduler
      |
      v
Workflow Execution
      |
      v
Workflows Batch connector
      |
      v
Cloud Batch jobs.create
      |
      v
Compute Engine VMs
      |
      v
Container Job
```

Azure:

```text
Logic Apps Recurrence Trigger
      |
      v
Logic Apps Workflow
      |
      v
Azure Batch REST API
      |
      v
Azure Batch Job
      |
      v
Azure Batch Pool
      |
      v
Container Task
```

## Provider Mapping

| Concept | AWS | GCP | Azure |
| --- | --- | --- | --- |
| Scheduler | EventBridge Scheduler | Cloud Scheduler | Logic Apps Recurrence Trigger |
| Workflow/orchestrator | Step Functions | Workflows | Logic Apps Workflow |
| Batch submit | AWS Batch SubmitJob | Cloud Batch jobs.create | Azure Batch REST create job/task |
| Batch definition/template | Batch Job Definition | Batch job request template in Workflow | Logic App Batch job/task request body |
| Batch runtime | Fargate Compute Environment | Compute Engine VMs via Cloud Batch | Azure Batch Pool VMs |
| Logs | CloudWatch Logs | Cloud Logging | Azure Batch task files / Azure Monitor / Logic App run history |
| Private networking | NAT/VPC endpoints | Private Google Access/Cloud NAT | VNet/Subnet/NAT Gateway/NoPublicIPAddresses |

## Repo Structure

- `modules/aws`: AWS building-block modules and the AWS scheduled batch wrapper.
- `modules/gcp`: GCP building-block modules and the GCP scheduled batch wrapper.
- `modules/azure`: Azure building-block modules and the Azure scheduled batch wrapper.
- `modules/multicloud`: Switcher wrapper that delegates to AWS, GCP, or Azure modules.
- `examples/aws`: Provider-specific AWS examples.
- `examples/gcp`: Provider-specific GCP examples.
- `examples/azure`: Provider-specific Azure examples.
- `examples/multicloud-switcher`: Shared-interface example using `cloud_provider`.

## Usage Options

### A. AWS Direct Usage

Use `modules/aws/scheduled-batch-job` when you want the AWS implementation directly.

```hcl
module "scheduled_batch_job" {
  source = "./modules/aws/scheduled-batch-job"

  name            = "scheduled-batch-aws"
  vpc_id          = "vpc-xxxxxxxxxxxxxxxxx"
  subnet_ids      = ["subnet-aaaaaaaaaaaaaaaaa"]
  container_image = "<aws-account-id>.dkr.ecr.eu-central-1.amazonaws.com/my-batch-job:latest"

  schedule_expression = "cron(0 3 * * ? *)"
  schedule_timezone   = "Europe/Belgrade"
}
```

### B. GCP Direct Usage

Use `modules/gcp/scheduled-batch-job` when you want the GCP implementation directly.

```hcl
module "scheduled_batch_job" {
  source = "./modules/gcp/scheduled-batch-job"

  project_id      = "<gcp-project-id>"
  region          = "europe-west1"
  name            = "scheduled-batch-gcp"
  container_image = "europe-west1-docker.pkg.dev/<gcp-project-id>/my-repo/my-image:latest"

  schedule  = "0 3 * * *"
  time_zone = "Europe/Belgrade"
}
```

### C. Azure Direct Usage

Use `modules/azure/scheduled-batch-job` when you want the Azure implementation directly.

```hcl
module "scheduled_batch_job" {
  source = "./modules/azure/scheduled-batch-job"

  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  location            = "westeurope"
  name                = "scheduled-batch-azure"

  container_image        = "mcr.microsoft.com/azure-cli:latest"
  container_command_line = "/bin/sh -c \"echo Hello from Azure Batch; date; env\""

  recurrence_frequency = "Day"
  recurrence_interval  = 1
  recurrence_time_zone = "Central Europe Standard Time"
  recurrence_hours     = [3]
  recurrence_minutes   = [0]
}
```

### D. Multicloud Switcher Usage

Use `modules/multicloud/scheduled-batch-job` when you want one Terraform interface and a provider switch.

```hcl
module "scheduled_batch_job" {
  source = "./modules/multicloud/scheduled-batch-job"

  cloud_provider  = "azure"
  name            = "scheduled-batch"
  container_image = "mcr.microsoft.com/azure-cli:latest"

  azure_config = {
    subscription_id     = var.subscription_id
    resource_group_name = var.resource_group_name
    location            = "westeurope"
  }
}
```

## CLI Usage

The `cli/` package provides a lightweight Python wrapper around Terraform. It generates a root deployment directory under `deployments/<cloud>/<name>` and then runs Terraform there.

It does not call cloud SDK APIs and does not create or store credentials. AWS, GCP, and Azure credentials come from the standard Terraform provider auth mechanisms.

Install for local development:

```bash
cd cli
python -m pip install -e .
```

Create a placeholder config:

```bash
scheduled-batch init-config
```

Render, plan, or create a workload:

```bash
scheduled-batch render --cloud aws --name daily-import
scheduled-batch plan --cloud gcp --name daily-import
scheduled-batch create --cloud azure --name daily-import --yes
```

Other commands:

```bash
scheduled-batch destroy --cloud aws --name daily-import --yes
scheduled-batch outputs --cloud gcp --name daily-import
scheduled-batch list
scheduled-batch doctor --cloud azure
```

Generated `deployments/` directories and local `.scheduled-batch/` config are ignored by `.gitignore`.

## Makefile Usage

The root `Makefile` is a convenience wrapper for `examples/multicloud-switcher`.

First create local tfvars files from the examples:

```bash
cp examples/multicloud-switcher/aws.tfvars.example examples/multicloud-switcher/aws.tfvars
cp examples/multicloud-switcher/gcp.tfvars.example examples/multicloud-switcher/gcp.tfvars
cp examples/multicloud-switcher/azure.tfvars.example examples/multicloud-switcher/azure.tfvars
```

Real `*.tfvars` files are ignored by `.gitignore`; keep credentials and secrets out of them.

AWS:

```bash
make init CLOUD=aws
make validate CLOUD=aws
make plan CLOUD=aws
make apply CLOUD=aws
```

GCP:

```bash
make init CLOUD=gcp
make validate CLOUD=gcp
make plan CLOUD=gcp
make apply CLOUD=gcp
```

Azure:

```bash
make init CLOUD=azure
make validate CLOUD=azure
make plan CLOUD=azure
make apply CLOUD=azure
```

Destroy uses the same provider switch:

```bash
make destroy CLOUD=aws
make destroy CLOUD=gcp
make destroy CLOUD=azure
```

## Azure Setup Notes

- Azure provider auth uses standard Azure authentication mechanisms, such as `az login`, workload identity, managed identity, or other AzureRM-supported flows.
- Secrets and Azure Batch shared keys are not used by these modules.
- The Logic App uses a system-assigned managed identity.
- The Logic App managed identity receives Batch RBAC on the Batch account scope.
- The Logic App calls the Azure Batch REST API with managed identity audience `https://batch.core.windows.net/`.
- Azure schedules use Logic Apps Recurrence configuration:
  - `frequency`
  - `interval`
  - `hours`
  - `minutes`
  - Windows time zone ID, for example `Central Europe Standard Time`

## Azure Network Notes

- Default Batch pools use `BatchManaged` public address provisioning.
- Use `public_address_provisioning_type = "NoPublicIPAddresses"` with `subnet_id` for no-public-IP pools.
- Use NAT Gateway when Batch tasks need outbound internet access, such as public image pulls or external APIs.
- Private ACR needs the Batch pool user-assigned managed identity, `AcrPull`, and planned network access such as private endpoints, DNS, service endpoints, or registry network rules.
- Azure Batch no-public-IP behavior depends on region support, Batch account settings, and simplified node communication requirements.

## Manual Testing

AWS:

```bash
aws stepfunctions start-execution --state-machine-arn "$(terraform output -raw state_machine_arn)" --input '{"manual": true}'
```

```bash
aws batch list-jobs --job-queue "$(terraform output -raw batch_job_queue_arn)" --job-status RUNNING
```

GCP:

```bash
gcloud workflows run WORKFLOW_NAME --location REGION --data='{"manual":true}'
```

```bash
gcloud scheduler jobs run JOB_NAME --location REGION
```

```bash
gcloud batch jobs list --location REGION
```

```bash
gcloud logging read 'resource.type="batch_task"' --limit 50
```

Azure:

```bash
az logic workflow run trigger --resource-group RESOURCE_GROUP --name LOGIC_APP_NAME --trigger-name Recurrence
```

```bash
az batch job list --account-name BATCH_ACCOUNT_NAME --account-endpoint "https://BATCH_ACCOUNT_ENDPOINT"
```

```bash
az batch task list --job-id JOB_ID --account-name BATCH_ACCOUNT_NAME --account-endpoint "https://BATCH_ACCOUNT_ENDPOINT"
```

```bash
az batch task show --job-id JOB_ID --task-id TASK_ID --account-name BATCH_ACCOUNT_NAME --account-endpoint "https://BATCH_ACCOUNT_ENDPOINT"
```

Azure command override:

Azure Batch task `commandLine` is a single string. This differs from AWS and GCP command inputs, which are commonly represented as `list(string)`.

```json
{
  "commandLine": "/bin/sh -c \"echo override from Logic App trigger; date; env\""
}
```

In the multicloud switcher, simple Azure commands can be derived by joining the common `container_command` list. For complex Azure commands, prefer `azure_config.container_command_line`.

## Troubleshooting

AWS:

- Batch job ostaje `RUNNABLE`: check the compute environment state, job queue attachment, subnet capacity, security group egress, and Fargate CPU/memory values.
- `CannotPullContainerError`: check the image URI, ECR access, NAT, or VPC endpoints for ECR API, ECR Docker, CloudWatch Logs, and S3.
- `AccessDenied` for `states:StartExecution`: check the Scheduler role policy, state machine ARN, trust policy source account, and source ARN.
- `AccessDenied` for `batch:SubmitJob`: check the Step Functions role policy for the exact job queue and job definition ARNs.
- CloudWatch logs se ne pojavljuju: check the execution role, log configuration, log group, region, and CloudWatch Logs endpoint for private subnets.

GCP:

- Cloud Scheduler ne pokreće workflow: check job state, schedule, timezone, target URI, and Scheduler service account.
- `PERMISSION_DENIED workflows.executions.create`: check `roles/workflows.invoker` on the Scheduler service account.
- `PERMISSION_DENIED batch.jobs.create`: check `roles/batch.jobsEditor` on the Workflow service account and ensure the Batch API is enabled.
- Caller cannot act as service account: check `roles/iam.serviceAccountUser` on the Batch runtime service account.
- Batch job ne može da povuče image: check Artifact Registry permissions and private egress path.
- Cloud Logging logs se ne pojavljuju: check `roles/logging.logWriter` on the runtime service account and `logsPolicy.destination = CLOUD_LOGGING`.

Azure:

- Logic App ne kreira Batch job: inspect Logic App run history and the Batch REST response body.
- Managed identity authentication failed: confirm the Logic App system-assigned identity exists and the workflow HTTP action uses managed identity authentication.
- Wrong audience for Batch API: use `https://batch.core.windows.net/` as the managed identity audience.
- Logic App 403 na Batch endpoint: confirm the Logic App identity has the configured Batch role assignment at the Batch account scope.
- Batch pool nodes unusable: check subnet capacity, Batch account settings, node agent SKU, VM quota, and network egress.
- Container image pull fails: check public internet egress, NAT Gateway, ACR `AcrPull`, private endpoints, DNS, and registry network rules.
- Task stuck active/running: check task command line, container startup, pool node health, max wall clock time, and task stdout/stderr.
- `NoPublicIPAddresses` unsupported/region issue: verify Azure Batch regional support and simplified node communication requirements.
- Azure Batch CLI auth context problem: confirm `az login`, `az account set`, and the Batch account endpoint/context used by `az batch`.

## Security Notes

AWS:

- Scheduler role only allows `states:StartExecution` on the specific state machine.
- Step Functions role only has the Batch access needed for submit and `.sync` monitoring.
- Batch job role is not admin by default.

GCP:

- No service account keys.
- No Owner, Editor, or Viewer roles.
- Scheduler service account only invokes Workflows.
- Workflow service account has Batch Jobs Editor plus Service Account User on the runtime service account.
- Runtime service account has only runtime permissions.

Azure:

- No service principal secrets.
- No Batch shared keys.
- No storage account key outputs.
- Logic App uses managed identity.
- Logic App identity gets only Batch job submitter/data contributor scope on the Batch account.
- Batch pool identity gets `AcrPull` only if needed.
- Secrets go in Azure Key Vault, not in `tfvars`.

General:

- Do not commit real `*.tfvars`, Terraform state files, credentials, or secrets.

# workflows-batch-submit

Deploys a Google Cloud Workflows workflow that creates a Cloud Batch container job at runtime.

This module is the GCP equivalent of the AWS Step Functions -> AWS Batch submit step. It does not create a `google_batch_job` Terraform resource. Every workflow execution calls the Batch API connector `googleapis.batch.v1.projects.locations.jobs.create` and generates a unique Batch job ID for that execution.

GCP Batch does not use an AWS-style job definition in this flow. The container image, command, environment, resources, machine type, service account, labels, and network settings are rendered into the workflow source.

## IAM

The module creates a user-managed service account for Workflows and grants it:

- `roles/batch.jobsEditor` on the project so it can create Batch jobs
- `roles/logging.logWriter` on the project for workflow logging
- `roles/iam.serviceAccountUser` on the Batch runtime service account so Batch VMs can run as that identity

Runtime permissions for the container belong on the Batch runtime service account, not on the Workflows service account.

## Basic Usage

```hcl
module "batch_runtime_iam" {
  source = "../batch-runtime-iam"

  project_id = var.project_id
  name       = var.name
}

module "workflow" {
  source = "../workflows-batch-submit"

  project_id                  = var.project_id
  region                      = var.region
  name                        = var.name
  container_image             = "europe-docker.pkg.dev/example/jobs/worker:latest"
  container_commands          = ["sh", "-c", "echo hello from batch; date"]
  batch_service_account_email = module.batch_runtime_iam.service_account_email
  batch_service_account_id    = module.batch_runtime_iam.service_account_id
}
```

## Private Network Usage

Pass `network`, `subnetwork`, and `no_external_ip_address = true` when Batch jobs should run without public IP addresses.

```hcl
module "workflow" {
  source = "../workflows-batch-submit"

  project_id                  = var.project_id
  region                      = var.region
  name                        = var.name
  container_image             = var.container_image
  batch_service_account_email = module.batch_runtime_iam.service_account_email
  batch_service_account_id    = module.batch_runtime_iam.service_account_id

  network                = "projects/my-project/global/networks/my-vpc"
  subnetwork             = "projects/my-project/regions/europe-west1/subnetworks/private-a"
  no_external_ip_address = true
}
```

The subnet should have Private Google Access or another private egress path required by your image registry and APIs.

## Command Override

Set `enable_command_override_from_args = true` to let workflow execution input override the default command. The `command` key must be a list of strings.

```hcl
module "workflow" {
  source = "../workflows-batch-submit"

  project_id                         = var.project_id
  region                             = var.region
  name                               = var.name
  container_image                    = var.container_image
  container_commands                 = ["sh", "-c", "echo default command"]
  batch_service_account_email        = module.batch_runtime_iam.service_account_email
  batch_service_account_id           = module.batch_runtime_iam.service_account_id
  enable_command_override_from_args  = true
}
```

Example execution argument:

```json
{
  "command": ["sh", "-c", "echo scheduled run; date; env"]
}
```

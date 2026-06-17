# Multicloud Scheduled Jobs

## Overview

This repository contains reusable Terraform modules and examples for scheduled container batch jobs on AWS, Google Cloud, and Azure.

AWS flow:

```text
EventBridge Scheduler -> Step Functions -> AWS Batch Fargate Job
```

GCP flow:

```text
Cloud Scheduler -> Workflows -> Cloud Batch container job
```

Azure flow:

```text
Azure Logic Apps Recurrence Trigger -> Azure Logic Apps Workflow -> Azure Batch REST API -> Azure Batch Pool -> Container Task
```

The repository also includes a multicloud switcher wrapper that selects the provider implementation with:

```hcl
cloud_provider = "aws"
```

or:

```hcl
cloud_provider = "gcp"
```

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

## Provider Mapping

| AWS component | GCP component |
| --- | --- |
| EventBridge Scheduler | Cloud Scheduler |
| Step Functions | Workflows |
| AWS Batch SubmitJob | Cloud Batch jobs.create |
| AWS Batch Job Definition | Batch job request template inside Workflow |
| AWS Batch Fargate | Cloud Batch on Compute Engine VMs |
| CloudWatch Logs | Cloud Logging |
| VPC endpoints | Private Google Access / Cloud NAT |

## Repo Structure

- `modules/aws`: AWS building-block modules and the AWS scheduled batch wrapper.
- `modules/gcp`: GCP building-block modules and the GCP scheduled batch wrapper.
- `modules/azure`: Azure skeleton modules for Logic Apps, Azure Batch, resource groups, resource providers, and private networking.
- `modules/multicloud`: Switcher wrapper that delegates to AWS or GCP modules.
- `examples/aws`: Provider-specific AWS examples.
- `examples/gcp`: Provider-specific GCP examples.
- `examples/azure`: Provider-specific Azure skeleton examples.
- `examples/multicloud-switcher`: Shared-interface example using `cloud_provider`.

## Usage Options

### AWS Direct Usage

Use `modules/aws/scheduled-batch-job` when you want the AWS implementation directly.

```hcl
module "scheduled_batch_job" {
  source = "./modules/aws/scheduled-batch-job"

  name            = "scheduled-batch-aws"
  vpc_id          = "vpc-xxxxxxxxxxxxxxxxx"
  subnet_ids      = ["subnet-aaaaaaaaaaaaaaaaa", "subnet-bbbbbbbbbbbbbbbbb"]
  container_image = "<aws-account-id>.dkr.ecr.eu-central-1.amazonaws.com/my-batch-job:latest"

  schedule_expression = "cron(0 3 * * ? *)"
  schedule_timezone   = "Europe/Belgrade"
}
```

### GCP Direct Usage

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

### Multicloud Switcher Usage

Use `modules/multicloud/scheduled-batch-job` when you want one Terraform interface and a provider switch.

```hcl
module "scheduled_batch_job" {
  source = "./modules/multicloud/scheduled-batch-job"

  cloud_provider  = "aws"
  name            = "scheduled-batch"
  container_image = "<provider-specific-image-uri>"

  aws_config = {
    vpc_id     = "vpc-xxxxxxxxxxxxxxxxx"
    subnet_ids = ["subnet-aaaaaaaaaaaaaaaaa"]
  }
}
```

## Multicloud Switcher

The switcher supports:

- `cloud_provider = "aws"`
- `cloud_provider = "gcp"`

Terraform module sources cannot be dynamic, so the switcher contains two static module blocks with `count`. Only the selected provider module creates resources.

`schedule_expression` is provider-specific:

- AWS uses EventBridge Scheduler format, for example `cron(0 3 * * ? *)`.
- GCP uses unix cron format, for example `0 3 * * *`.

AWS-specific inputs go in `aws_config`, including VPC ID, subnet IDs, public IP behavior, Batch sizing, and Scheduler group name.

GCP-specific inputs go in `gcp_config`, including project ID, region, Batch task sizing, runtime service account roles, network, subnetwork, and private IP behavior.

## Makefile Usage

The root `Makefile` is a convenience wrapper for `examples/multicloud-switcher`.

First create local tfvars files from the examples:

```bash
cp examples/multicloud-switcher/aws.tfvars.example examples/multicloud-switcher/aws.tfvars
cp examples/multicloud-switcher/gcp.tfvars.example examples/multicloud-switcher/gcp.tfvars
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

Destroy uses the same provider switch:

```bash
make destroy CLOUD=aws
make destroy CLOUD=gcp
```

## AWS Setup Notes

- Private subnet + NAT Gateway: use `assign_public_ip = false`; Fargate reaches ECR, CloudWatch Logs, and other endpoints through NAT.
- Private subnet + VPC endpoints: use `assign_public_ip = false` and `modules/aws/vpc-endpoints-fargate` for ECR API, ECR Docker, CloudWatch Logs, and S3 gateway access.
- Public subnet + public IP: use `assign_public_ip = true` only when public subnet routing and security controls are intentional.
- Step Functions uses the optimized synchronous Batch integration: `arn:${data.aws_partition.current.partition}:states:::batch:submitJob.sync`.

## GCP Setup Notes

- `serviceusage.googleapis.com` must be enabled before Terraform can manage project services:

```bash
gcloud services enable serviceusage.googleapis.com --project PROJECT_ID
```

- `modules/gcp/project-services` enables the APIs needed by the GCP flow.
- Private Google Access lets private Batch VMs reach Google APIs without external IP addresses.
- Cloud NAT is optional and is useful when private Batch VMs need outbound access to non-Google endpoints.
- Cloud Batch runs the container on Compute Engine VMs.
- Workflows submits the Batch job at runtime through the Batch API connector; the repo does not create a static `google_batch_job` resource for this flow.

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

## Troubleshooting

AWS Batch job remains `RUNNABLE`:

- Confirm the compute environment is `VALID` and `ENABLED`.
- Check that the job queue is enabled and attached to the Fargate compute environment.
- Verify subnet capacity and security group egress.
- Confirm requested vCPU and memory values are valid for Fargate.

AWS `CannotPullContainerError`:

- Confirm the image URI exists in the selected AWS region.
- For private subnets without NAT, ensure ECR API, ECR Docker, CloudWatch Logs, and S3 endpoints exist.
- Ensure the S3 gateway endpoint is attached to the private subnet route tables.
- Ensure endpoint security group ingress allows TCP 443 from the Batch task security group.

AWS `AccessDenied` for `states:StartExecution`:

- Check the Scheduler execution role policy.
- Confirm it allows `states:StartExecution` on the exact state machine ARN.
- Check the Scheduler trust policy source account and source ARN conditions.

AWS `AccessDenied` for `batch:SubmitJob`:

- Check the Step Functions execution role policy.
- Confirm it allows `batch:SubmitJob` on the exact job queue ARN and job definition ARN.
- Confirm it includes the `.sync` monitoring permissions.

AWS CloudWatch logs do not appear:

- Confirm the Batch execution role has the Amazon ECS task execution managed policy.
- Confirm the Batch job definition log configuration points to the expected log group and region.
- For private subnets, confirm the CloudWatch Logs VPC endpoint permits TCP 443 from the Batch task security group.

GCP Cloud Scheduler does not start the workflow:

- Confirm the Scheduler job is not paused.
- Check the schedule and timezone.
- Confirm the HTTP target points to the Workflows executions API URI.

GCP `PERMISSION_DENIED` for `workflows.executions.create`:

- Confirm the Scheduler service account has `roles/workflows.invoker`.
- Confirm the OAuth token service account email matches the Scheduler service account.

GCP `PERMISSION_DENIED` for `batch.jobs.create`:

- Confirm the Workflows service account has `roles/batch.jobsEditor`.
- Confirm the Batch API is enabled.

GCP caller cannot act as service account:

- Confirm the Workflows service account has `roles/iam.serviceAccountUser` on the Batch runtime service account.
- Confirm the runtime service account ID passed to the workflow module is the full service account resource name.

GCP Batch job cannot pull the image:

- Confirm the image URI exists and the runtime service account has the required registry read role, such as `roles/artifactregistry.reader`.
- For private jobs, confirm Private Google Access is enabled or another private egress path exists.

GCP Cloud Logging logs do not appear:

- Confirm the Batch runtime service account has `roles/logging.logWriter`.
- Confirm the workflow Batch job request uses `logsPolicy.destination = CLOUD_LOGGING`.

GCP private job cannot access Google APIs:

- Confirm the subnet has Private Google Access enabled.
- Confirm required APIs are enabled through `modules/gcp/project-services`.
- Add Cloud NAT only if the job needs outbound access to non-Google endpoints.

## Security Notes

AWS:

- The Batch job role is not an admin role by default.
- Add runtime permissions only to the Batch job role.
- The Scheduler role should only allow `states:StartExecution` on the specific state machine.
- The Step Functions role should allow only the Batch access required for submit and `.sync` monitoring.

GCP:

- Do not create service account keys.
- Do not use broad Owner, Editor, or Viewer roles.
- The Scheduler service account should only invoke Workflows.
- The Workflow service account should have Batch Jobs Editor plus Service Account User on the runtime service account.
- The runtime service account should have only the permissions needed by the container at runtime.

General:

- Do not commit real `*.tfvars`, Terraform state files, credentials, or secrets.
- Do not put secret values in `tfvars`; use AWS Secrets Manager or Google Cloud Secret Manager and grant only the runtime role or runtime service account the access it needs.

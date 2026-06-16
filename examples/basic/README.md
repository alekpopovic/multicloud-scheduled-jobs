# Basic example

Minimal example showing how to use the `scheduled-batch-job` wrapper module.

This example creates the complete scheduled Batch flow through reusable modules:

```text
EventBridge Scheduler -> Step Functions -> AWS Batch Fargate Job
```

It expects an existing VPC, subnets, and container image. The example does not create AWS resources directly outside the wrapper module call.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

## Manual Run

Start a Step Functions execution manually:

```bash
aws stepfunctions start-execution --state-machine-arn "$(terraform output -raw state_machine_arn)" --input '{"manual": true}'
```

List running AWS Batch jobs:

```bash
aws batch list-jobs --job-queue "$(terraform output -raw batch_job_queue_arn)" --job-status RUNNING
```

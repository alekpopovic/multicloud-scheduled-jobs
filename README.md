# AWS Batch Scheduled Jobs

## Overview

Reusable Terraform module architecture for scheduled AWS Batch jobs running on Fargate.

Target flow:

```text
EventBridge Scheduler -> AWS Step Functions -> AWS Batch SubmitJob -> AWS Batch Fargate Job
```

This repository intentionally does not create AWS resources from the root directory. All AWS resources should live in reusable modules, and runnable configurations should live under `examples/`.

## Architecture

The architecture is split into small modules that can be composed directly or through the higher-level `scheduled-batch-job` module.

- EventBridge Scheduler invokes a Step Functions state machine.
- Step Functions submits an AWS Batch job using the service integration.
- AWS Batch runs the job on Fargate.
- Optional VPC endpoints support private subnet deployments.

## Modules

- `modules/batch-fargate`: AWS Batch Fargate compute environment, job queue, job definition, and related IAM.
- `modules/stepfunctions-batch-submit`: Step Functions state machine for synchronous AWS Batch `SubmitJob`.
- `modules/eventbridge-scheduler-sfn`: EventBridge Scheduler schedule targeting Step Functions.
- `modules/vpc-endpoints-fargate`: VPC endpoints commonly needed by private Fargate workloads.
- `modules/scheduled-batch-job`: Composition module for the full scheduled Batch job pattern.

## Examples

- `examples/basic`: Minimal example using the scheduled Batch job composition.
- `examples/private-subnet-with-vpc-endpoints`: Private subnet example with VPC endpoints.

## Usage

```bash
cd examples/basic
terraform init
terraform plan
```

Copy `terraform.tfvars.example` to a local `terraform.tfvars` file before planning or applying an example.

## Troubleshooting

- Run `terraform fmt -recursive` before opening a pull request.
- Ensure the selected AWS region supports AWS Batch on Fargate, Step Functions, and EventBridge Scheduler.
- Check IAM permissions for Terraform, Step Functions, EventBridge Scheduler, and AWS Batch service roles.

## Security notes

- Do not commit `*.tfvars` files containing environment-specific or sensitive values.
- Do not hardcode AWS account IDs or partitions.
- Prefer least-privilege IAM policies when module implementations are added.
- Lambda and EC2 AWS Batch compute environments are intentionally out of scope for this architecture.

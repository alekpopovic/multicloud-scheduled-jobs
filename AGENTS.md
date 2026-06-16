# Repository Instructions

## Project

This repository contains Terraform modules and examples for scheduled AWS Batch jobs on Fargate.

Target architecture:

```text
EventBridge Scheduler -> AWS Step Functions -> AWS Batch SubmitJob -> AWS Batch Fargate Job
```

## Ground Rules

- Keep the root directory free of Terraform resources.
- Put AWS resources in reusable modules under `modules/`.
- Put runnable examples under `examples/`.
- Do not use Lambda.
- Do not use EC2 AWS Batch compute environments.
- AWS Batch compute environments must use Fargate.
- Do not hardcode AWS account IDs.
- Do not hardcode AWS partitions.
- Use `data.aws_caller_identity.current` and `data.aws_partition.current` where account or partition context is needed.
- EventBridge schedules must use `aws_scheduler_schedule`.
- Step Functions Batch integration must use `arn:${data.aws_partition.current.partition}:states:::batch:submitJob.sync`.

## Terraform Standards

- Terraform `required_version` must be `>= 1.5.0`.
- AWS provider version must be `>= 5.0`.
- Run `terraform fmt -recursive` after editing Terraform files.
- Keep examples self-contained and provider-configured through `var.aws_region`.
- Do not commit `*.tfvars`; use `*.tfvars.example` for sample values.
- Do not ignore `.terraform.lock.hcl`.

## Repository Layout

- `modules/batch-fargate`: AWS Batch Fargate resources and IAM.
- `modules/stepfunctions-batch-submit`: Step Functions state machine for synchronous Batch submit jobs.
- `modules/eventbridge-scheduler-sfn`: EventBridge Scheduler invoking Step Functions.
- `modules/vpc-endpoints-fargate`: VPC endpoints for private Fargate workloads.
- `modules/scheduled-batch-job`: Composition module for the full scheduled job pattern.
- `examples/basic`: Minimal usage example.
- `examples/private-subnet-with-vpc-endpoints`: Private subnet usage example.

## Validation

Before finishing changes, run:

```bash
terraform fmt -recursive
terraform fmt -check -recursive
```

Add deeper `terraform validate` coverage once module implementations are complete.

## Git Workflow

After each prompt that changes files, run:

```bash
git status --short
git add .
git commit -m "<concise change summary>"
git push
```

Check the staged diff before committing when practical. Do not commit secrets, local `*.tfvars` files, Terraform state, or unrelated user changes.

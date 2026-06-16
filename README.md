# AWS Batch Scheduled Jobs

## Project Overview

This repository contains reusable Terraform modules for scheduled AWS Batch jobs running on Fargate.

Target flow:

```text
EventBridge Scheduler -> Step Functions -> AWS Batch Fargate Job
```

The root directory does not create AWS resources directly. Reusable infrastructure lives under `modules/`, and runnable examples live under `examples/`.

## Architecture

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

EventBridge Scheduler starts a Step Functions state machine. The state machine submits an AWS Batch job with the optimized synchronous Batch integration. AWS Batch places the job on a queue backed by a Fargate compute environment, then runs the configured container.

## Modules

- `modules/batch-fargate`: Creates the AWS Batch Fargate compute environment, job queue, job definition, CloudWatch Log Group, task security group, and IAM roles for Batch, task execution, and job runtime.
- `modules/stepfunctions-batch-submit`: Creates a Standard Step Functions state machine that uses `batch:submitJob.sync` and an execution role with permissions to submit and monitor Batch jobs.
- `modules/eventbridge-scheduler-sfn`: Creates an EventBridge Scheduler schedule, execution role, and least-privilege `states:StartExecution` policy for a target state machine.
- `modules/vpc-endpoints-fargate`: Creates optional VPC endpoints for private subnet Fargate jobs: ECR API, ECR Docker, CloudWatch Logs, and S3 gateway.
- `modules/scheduled-batch-job`: Convenience wrapper that composes the Batch, Step Functions, and Scheduler modules into one scheduled job flow.

The first four modules are building blocks. Use them directly when you need separate lifecycles, shared Batch infrastructure, multiple schedules, custom state machines, or custom IAM wiring.

Use `modules/scheduled-batch-job` when you want the standard end-to-end flow with a compact input interface.

## Examples

- `examples/basic`: Minimal wrapper usage for an existing VPC and subnets.
- `examples/private-subnet-with-vpc-endpoints`: Wrapper usage with VPC endpoints for private subnets without a NAT Gateway.

## Basic Usage

```hcl
module "scheduled_batch_job" {
  source = "./modules/scheduled-batch-job"

  name            = "daily-report"
  vpc_id          = "vpc-xxxxxxxxxxxxxxxxx"
  subnet_ids      = ["subnet-aaaaaaaaaaaaaaaaa", "subnet-bbbbbbbbbbbbbbbbb"]
  container_image = "<aws-account-id>.dkr.ecr.eu-central-1.amazonaws.com/my-batch-job:latest"

  assign_public_ip    = false
  schedule_expression = "cron(0 3 * * ? *)"
  schedule_timezone   = "Europe/Belgrade"

  environment_variables = {
    APP_ENV   = "prod"
    LOG_LEVEL = "info"
  }

  tags = {
    Project = "scheduled-batch"
    Env     = "prod"
  }
}
```

## Network Options

- Private subnet with NAT Gateway: keep `assign_public_ip = false`. Fargate uses NAT for ECR, CloudWatch Logs, and other outbound traffic.
- Private subnet with VPC endpoints: keep `assign_public_ip = false` and use `modules/vpc-endpoints-fargate` for ECR, CloudWatch Logs, and S3 access without NAT.
- Public subnet with public IP: set `assign_public_ip = true`. Use this only when public subnet routing and security controls are appropriate.

## Manual Testing

Start the Step Functions state machine manually:

```bash
aws stepfunctions start-execution --state-machine-arn "$(terraform output -raw state_machine_arn)" --input '{"manual": true}'
```

List running Batch jobs:

```bash
aws batch list-jobs --job-queue "$(terraform output -raw batch_job_queue_arn)" --job-status RUNNING
```

## Troubleshooting

Batch job remains `RUNNABLE`:

- Confirm the compute environment is `VALID` and `ENABLED`.
- Check that the job queue is enabled and attached to the Fargate compute environment.
- Verify subnet capacity and security group egress.
- Confirm requested vCPU and memory values are valid for Fargate.

`CannotPullContainerError`:

- Confirm the image URI exists in the selected AWS region.
- For private subnets without NAT, ensure ECR API, ECR Docker, CloudWatch Logs, and S3 endpoints exist.
- Ensure the S3 gateway endpoint is attached to the private subnet route tables.
- Ensure endpoint security group ingress allows TCP 443 from the Batch task security group.

`AccessDenied` for `states:StartExecution`:

- Check the EventBridge Scheduler execution role policy.
- Confirm it allows `states:StartExecution` on the exact state machine ARN.
- Check the Scheduler trust policy source account and source ARN conditions.

`AccessDenied` for `batch:SubmitJob`:

- Check the Step Functions execution role policy.
- Confirm it allows `batch:SubmitJob` on the exact job queue ARN and job definition ARN.
- Confirm it includes the monitoring permissions required by `.sync`.

CloudWatch logs do not appear:

- Confirm the Batch execution role has the Amazon ECS task execution managed policy.
- Confirm the Batch job definition log configuration points to the expected log group and region.
- For private subnets, confirm the CloudWatch Logs VPC endpoint exists and permits TCP 443 from the Batch task security group.

Scheduler does not start the state machine:

- Confirm the schedule is `ENABLED`.
- Check schedule expression and timezone.
- Check Scheduler target input is valid JSON.
- Check Scheduler role trust conditions and `states:StartExecution` permissions.

## Security Notes

- Do not add broad admin policies to the Batch job role.
- Add runtime permissions only to the Batch job role, such as S3, DynamoDB, Secrets Manager, or SQS permissions required by the container.
- Use the execution role for ECR image pulls and CloudWatch Logs writes.
- The Scheduler role should only allow `states:StartExecution` on the specific state machine.
- The Step Functions role should allow `batch:SubmitJob` only on the specific Batch queue and job definition.
- Do not commit real `*.tfvars`, Terraform state files, credentials, or secrets.

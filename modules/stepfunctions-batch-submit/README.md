# stepfunctions-batch-submit

Terraform module skeleton for a Step Functions state machine that submits AWS Batch jobs synchronously.

## TODO

- Add state machine definition using `arn:${data.aws_partition.current.partition}:states:::batch:submitJob.sync`.
- Add least-privilege IAM for `SubmitJob`, `DescribeJobs`, and related EventBridge integration permissions.

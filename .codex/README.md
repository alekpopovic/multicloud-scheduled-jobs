# Codex Notes

This directory is reserved for Codex-specific repository context, plans, and future automation helpers.

Start with the root `AGENTS.md` for active repository instructions.

## Current Focus

- Build reusable Terraform modules for scheduled AWS Batch jobs on Fargate.
- Keep root Terraform resource-free.
- Implement AWS resources incrementally in follow-up prompts.
- Follow the root `AGENTS.md` Git Workflow: after prompts that change files, add, commit, and push the completed changes.

## Pending Implementation Areas

- AWS Batch Fargate compute environment, job queue, job definition, and IAM.
- Step Functions state machine using synchronous AWS Batch SubmitJob integration.
- EventBridge Scheduler schedule and invocation IAM.
- VPC endpoints for private subnet Fargate workloads.
- Composition wiring in `modules/scheduled-batch-job`.
- Example validation in GitHub Actions.

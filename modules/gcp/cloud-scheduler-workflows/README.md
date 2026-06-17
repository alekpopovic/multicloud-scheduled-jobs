# cloud-scheduler-workflows

Creates a Google Cloud Scheduler job that starts a Google Cloud Workflows execution through an HTTP target.

The job sends a `POST` request to the Workflows executions API:

```text
https://workflowexecutions.googleapis.com/v1/projects/PROJECT_ID/locations/WORKFLOW_REGION/workflows/WORKFLOW_NAME/executions
```

This module does not use Pub/Sub, Cloud Functions, or Cloud Run.

## Workflow Argument

`workflow_argument` is a Terraform object passed to Workflows as the execution argument.

```hcl
workflow_argument = {
  source = "cloud-scheduler"
  name   = "nightly-job"
}
```

The Workflows executions API expects this request body:

```json
{
  "argument": "<JSON string>"
}
```

For that reason the module uses a double encode:

```hcl
body = base64encode(jsonencode({
  argument = jsonencode(var.workflow_argument)
}))
```

The outer `jsonencode` builds the API request body. The inner `jsonencode` turns your argument object into the JSON string expected by Workflows. `base64encode` is required by the Terraform `google_cloud_scheduler_job` HTTP target schema.

## OAuth Token

Cloud Scheduler authenticates to the Workflows executions API with an OAuth token minted for a user-managed Scheduler service account. The Google provider used by this module does not expose a workflow-level IAM member resource, so the module grants `roles/workflows.invoker` at project level.

## Usage

```hcl
module "scheduler" {
  source = "../cloud-scheduler-workflows"

  project_id      = var.project_id
  region          = var.scheduler_region
  name            = var.name
  workflow_name   = module.workflow.workflow_name
  workflow_region = module.workflow.workflow_region

  schedule  = "0 3 * * *"
  time_zone = "Europe/Belgrade"

  workflow_argument = {
    source = "cloud-scheduler"
    name   = var.name
  }
}
```

## Manual Test

Run the Scheduler job manually:

```bash
gcloud scheduler jobs run JOB_NAME --location REGION
```

For example:

```bash
gcloud scheduler jobs run scheduled-batch-schedule --location europe-west1
```

## Notes

Cloud Scheduler jobs do not currently use `labels` in this module because the Terraform resource does not expose a labels argument in the supported provider shape used here.

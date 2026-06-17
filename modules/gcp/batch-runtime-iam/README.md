# batch-runtime-iam

Terraform module for creating a user-managed service account for Google Cloud Batch runtime VMs.

This module does not use the default Compute Engine service account and does not create a service account key.

## What This Module Creates

- `google_service_account.batch_runtime`
- `google_project_iam_member.runtime_roles` for the configured runtime roles

Default runtime roles:

- `roles/logging.logWriter`
- `roles/artifactregistry.reader`

## Usage

```hcl
module "batch_runtime_iam" {
  source = "../../../modules/gcp/batch-runtime-iam"

  project_id = var.project_id
  name       = var.name
}
```

## Runtime Permissions

Runtime roles should be minimal and workload-specific. Add access for services such as Secret Manager, Cloud Storage, BigQuery, Pub/Sub, or other APIs through `additional_runtime_roles`.

Do not add broad roles such as Owner, Editor, or Viewer. Do not grant runtime permissions to scheduler or workflow service accounts when the container is the component that needs access.

## Service Account Keys

This module does not create service account keys. Prefer attaching the service account directly to GCP Batch jobs.

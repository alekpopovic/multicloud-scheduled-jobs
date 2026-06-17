# project-services

Terraform module for enabling Google APIs required by the GCP scheduled Batch job stack:

```text
Cloud Scheduler -> Workflows -> Cloud Batch container job
```

This module does not create a GCP project.

## Bootstrap

Terraform cannot use `google_project_service` until the Service Usage API is already enabled. Enable it manually before applying this module:

```bash
gcloud services enable serviceusage.googleapis.com --project PROJECT_ID
```

This module intentionally does not try to enable `serviceusage.googleapis.com`.

## Usage

```hcl
module "project_services" {
  source = "../../../modules/gcp/project-services"

  project_id = var.project_id
}
```

## Destroy Behavior

APIs are not disabled on destroy by default:

```hcl
disable_on_destroy = false
```

This is safer for shared projects because disabling APIs can affect unrelated workloads.

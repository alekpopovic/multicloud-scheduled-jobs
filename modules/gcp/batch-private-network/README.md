# batch-private-network

Optional helper module for Google Cloud Batch jobs that run without external IP addresses.

The module creates:

- a custom mode VPC network
- a regional subnet with `private_ip_google_access = true`
- an optional Cloud Router and Cloud NAT

It is not required by the GCP scheduled job wrapper. Use it when you want the module to create a simple private network for Batch runtime VMs.

## Private Google Access

Private Google Access lets VMs without external IP addresses reach Google APIs and services through internal IP paths. This is useful for Cloud Batch jobs that pull images from Artifact Registry and write logs to Cloud Logging while running with `no_external_ip_address = true`.

## When To Use Cloud NAT

Private Google Access covers Google APIs and services. Create Cloud NAT when the Batch container needs outbound internet access to non-Google endpoints, such as public package repositories, third-party APIs, or external artifact sources.

Set `create_cloud_nat = false` when the job only needs Google APIs and private network resources.

Set `create_cloud_nat = true` when private Batch VMs need controlled outbound internet access without public IP addresses.

## Batch Configuration

Batch jobs should use:

```hcl
no_external_ip_address = true
```

Pass this module's network outputs into `modules/gcp/workflows-batch-submit`:

```hcl
module "private_network" {
  source = "../batch-private-network"

  project_id       = var.project_id
  region           = var.region
  name             = var.name
  ip_cidr_range    = "10.10.0.0/24"
  create_cloud_nat = false
}

module "workflow" {
  source = "../workflows-batch-submit"

  project_id                  = var.project_id
  region                      = var.region
  name                        = var.name
  container_image             = var.container_image
  batch_service_account_email = module.batch_runtime_iam.service_account_email
  batch_service_account_id    = module.batch_runtime_iam.service_account_id

  network                = module.private_network.network_self_link
  subnetwork             = module.private_network.subnetwork_self_link
  no_external_ip_address = true
}
```

# scheduled-batch-cli

CLI wrapper for this repository's Terraform modules. It renders a Terraform root deployment and then shells out to Terraform.

It does not call AWS, Google Cloud, or Azure SDK APIs directly. It does not create or store credentials. Provider authentication comes from the standard Terraform provider mechanisms:

- AWS environment variables, AWS profiles, SSO, or IAM roles
- GCP ADC, gcloud auth, or workload identity
- Azure CLI login, workload identity, or managed identity

## Install For Development

```bash
cd cli
python -m pip install -e .
```

## Commands

```bash
scheduled-batch init-config
scheduled-batch render --cloud aws --name daily-import
scheduled-batch plan --cloud gcp --name daily-import
scheduled-batch create --cloud azure --name daily-import --yes
scheduled-batch destroy --cloud aws --name daily-import --yes
scheduled-batch outputs --cloud gcp --name daily-import
scheduled-batch list
scheduled-batch doctor --cloud azure
```

## Config

Default config path:

```text
~/.scheduled-batch/config.json
```

Create a placeholder config:

```bash
scheduled-batch init-config
```

Edit the generated file and replace placeholder IDs and image URIs before running `render`, `plan`, or `create`.

## Deployments

Default deployment path:

```text
./deployments/<cloud>/<name>
```

Generated deployments use `modules/multicloud/scheduled-batch-job` and include:

- `versions.tf`
- `providers.tf`
- `variables.tf`
- `main.tf`
- `outputs.tf`
- `terraform.tfvars.json`

The deployment directory is intentionally ignored by the root `.gitignore`.

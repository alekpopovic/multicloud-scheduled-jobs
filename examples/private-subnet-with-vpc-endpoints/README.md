# Private subnet with VPC endpoints example

Example showing how the scheduled Batch job composition module can be used with VPC endpoints for private subnet workloads.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

## TODO

- Update endpoint inputs once `vpc-endpoints-fargate` is implemented.
- Add validation instructions once resources are implemented.

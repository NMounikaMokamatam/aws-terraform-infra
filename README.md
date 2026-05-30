# aws-terraform-infra

Production-grade AWS infrastructure modules. Modular, reusable, and environment-aware.

## Structure

## Usage
```bash
cd environments/prod
terraform init
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## Features
- Remote state in S3 with DynamoDB locking
- Environment-specific variable files
- Least-privilege IAM roles
- Private EKS node groups with auto-scaling (2–10 nodes)
- Secrets encrypted with KMS
- Full cluster logging enabled (api, audit, authenticator)

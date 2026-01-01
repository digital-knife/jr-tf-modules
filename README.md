# AWS Infrastructure Modules

Reusable **Terraform** modules and **Terragrunt** orchestrations for secure, production-grade AWS infrastructure. 
Built with best practices: input validation, automated tagging, remote state locking, and modular design.

### Orchestration & Structure

- **Terragrunt**: Manages environment isolation (dev, automation) and keeps code DRY.
- **Remote State**: S3 backend with DynamoDB state locking enabled.
- **Global Config**: Centralized variables via `_global/common_vars.yaml` for account-wide governance.

**Core Infrastructure**

- **terraform-aws-s3-secure-bucket**: Production-grade S3 with versioning, encryption, and public access blocks.
- **terraform-aws-vpc**: Multi-AZ network with public/private subnets and NAT Gateways.
- **terraform-aws-dynamodb**: Encrypted tables for application data and Terraform state locking.

**Coming Soon**

- **Compute**: EC2 Baseline (SSM-enabled), Auto Scaling Groups (ASG), and Application Load Balancers (ALB).
- **Security & Identity**: Scoped IAM Roles, OIDC for GitHub Actions, and KMS Encryption.
- **Database & Serverless**: Managed RDS (Multi-AZ) and Lambda (VPC-integrated).
- **Monitoring**: Centralized CloudWatch Dashboards and SNS Operational Alarms.

### Tech Stack

- **Orchestration**: Terragrunt
- **IaC**: Terraform 1.x (Modules, Validation, Lifecycle Hooks)
- **Cloud**: AWS (Full Stack)

### --- Deploying an Environment ---

```hcl
cd environments/dev/vpc
terragrunt plan
terragrunt apply
```

### --- Remote Module Usage (HTTPS) ---

```hcl
module "automation_assets" {
  # The double slash // is mandatory to point to the sub-folder in the repo
  source = "git::[https://github.com/digital-knife/jr-tf-modules.git//modules/s3_bucket?ref=main](https://github.com/digital-knife/jr-tf-modules.git//modules/s3_bucket?ref=main)"

  bucket_name   = "jr-automation-assets-${local.account_id}"
  force_destroy = true
  tags          = local.common_tags
}
```

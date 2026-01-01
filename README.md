# AWS Infrastructure Modules

Reusable **Terraform** modules and **Terragrunt** orchestrations for secure, production-grade AWS infrastructure. 
Built with best practices: input validation, automated tagging, remote state locking, and modular design.

### Orchestration & Structure
- **Terragrunt**: Manages environment isolation (dev, automation) and keeps code DRY.
- **Remote State**: S3 backend with DynamoDB state locking enabled.
- **Global Config**: Centralized variables via `_global/common_vars.yaml` for account-wide governance.

### Current Modules
**Core Networking & Security**
- **terraform-aws-vpc**: Multi-AZ VPC with public/private subnet segmentation, NAT Gateways, and Flow Logs.
- **terraform-aws-security-group**: Standardized SG templates with strict ingress/egress rule validation.
- **terraform-aws-iam**: Scoped IAM roles, instance profiles, and OpenID Connect (OIDC) for GitHub Actions.

**Compute & Storage**
- **terraform-aws-s3-secure-bucket**: Secure S3 module with versioning, AES256 encryption, and Public Access Block.
- **terraform-aws-ec2-baseline**: Hardened EC2 instances with custom AMIs and integration with SSM for session management.
- **terraform-aws-autoscaling**: ASG configurations with health checks and Application Load Balancer (ALB) attachment.

**Database & Serverless**
- **terraform-aws-rds**: Managed Relational Database Service with Multi-AZ, automated backups, and encryption.
- **terraform-aws-dynamodb**: Encrypted tables for application data and Terraform state locking.
- **terraform-aws-lambda**: Serverless functions with scoped IAM execution roles and VPC connectivity.

**Operations & Monitoring**
- **terraform-aws-cloudwatch**: Centralized logging, metric filters, and SNS-backed operational alarms.
- **terraform-aws-kms**: Customer Managed Keys (CMK) for enterprise-wide data encryption.

### Tech Stack
- **Orchestration**: Terragrunt
- **IaC**: Terraform 1.x (Modules, Validation, Lifecycle Hooks)
- **Cloud**: AWS (Full Stack)
### Example Usage (Terragrunt)
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

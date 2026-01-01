# AWS Infrastructure Modules

Reusable **Terraform** modules and **Terragrunt** orchestrations for secure, production-grade AWS infrastructure. 
Built with best practices: input validation, automated tagging, remote state locking, and modular design.

### Orchestration & Structure

- **Terragrunt**: Manages environment isolation (dev, automation) and keeps code DRY.
- **Remote State**: S3 backend with DynamoDB state locking enabled.
- **Global Config**: Centralized variables via `_global/common_vars.yaml` for account-wide governance.

### Current Modules

### Current Modules

**Core Infrastructure**
- **S3 Secure Bucket**: High-security storage with versioning, encryption, and full 
  public access blocking. Implements strict naming validation and lifecycle 
  rules for production-grade data safety.
- **VPC**: Multi-AZ network architecture featuring public and private subnet 
  segmentation. Includes integrated NAT Gateways and Flow Logs for secure, 
  audited traffic management.
- **DynamoDB**: Scalable NoSQL tables featuring enterprise encryption and 
  high availability. Configured specifically for application data and 
  secure Terraform state locking.
- **EC2 Compute**: Hardened baseline instances featuring custom AMIs and 
  automated user-data scripts for software provisioning. Includes SSM 
  integration for secure, passwordless session management.
- **Application Load Balancer**: High-availability traffic distribution across 
  multiple availability zones with integrated health checks. Manages SSL 
  termination and intelligent routing to back-end target groups.

**Coming Soon**
- **IAM Governance**: Centralized identity management featuring scoped 
  execution roles and least-privilege policies. Implements OIDC providers 
  to enable secure authentication for GitHub Actions.
- **RDS Database**: Managed relational databases with Multi-AZ failover and 
  automated backup retention policies. Includes encrypted storage and 
  integrated security groups for private network isolation.
- **Lambda Serverless**: Event-driven functions with scoped IAM execution 
  roles and private VPC connectivity. Configured for automated 
  infrastructure tasks and cost-efficient backend logic.
- **CloudWatch & Monitoring**: Centralized operational dashboards featuring 
  real-time metric filters and automated SNS alarms. Provides full 
  visibility into resource health across all environments.

### Tech Stack

- **Orchestration**: Terragrunt
- **IaC**: Terraform 1.x (Modules, Validation, Lifecycle Hooks)
- **Cloud**: AWS (Full Stack)

### --- Deploying an Environment ---

```hcl
git clone https://github.com/digital-knife/jr-tf-modules.git
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

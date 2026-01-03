# AWS Infrastructure Modules

Reusable **Terraform** modules and **Terragrunt** orchestrations for secure, production-grade AWS infrastructure. 
Built with best practices: input validation, automated tagging, remote state locking, modular design, and 
decoupled state architecture for minimized blast radius and high concurrency.

## Orchestration & Structure

- **Terragrunt**: Manages environment isolation (dev, automation) and keeps code DRY.
- **Remote State**: S3 backend with DynamoDB state locking enabled.
- **Global Config**: Centralized variables via `_global/common_vars.yaml` for account-wide governance.

## Current Modules

**Core Infrastructure**

- **VPC**: Multi-AZ network architecture featuring public and private subnet 
  segmentation. Includes integrated NAT Gateways and Flow Logs for secure, 
  audited traffic management.

- **EC2 Compute**: Standardized Linux baselines featuring automated Nginx provisioning
  via user_data scripts. Integrated with AWS Systems Manager (SSM) for secure, terminal-based 
  management without the need for open SSH ports.

- **Application Load Balancer**: High-availability traffic distribution across 
  multiple AZs with integrated health checks. Manages SSL termination and 
  intelligent routing to back-end target groups.

- **CI/CD via GitHub Actions & GitOps**: Fully automated "Plan-on-PR" and "Apply-on-Merge" 
  pipeline. Uses OIDC for keyless AWS authentication, providing a secure, immutable 
  audit trail for every infrastructure change.

- **Tiered Security Groups (The Handshake)**: Industry-standard Security Group Chaining. The ALB is 
  the only component open to the internet; Compute instances are hardened to accept traffic only 
  from the ALB Security Group ID, eliminating IP-based lateral movement risks.

- **S3 & DynamoDB (Backend)**: Production-grade remote state management with automated state 
  locking via DynamoDB and AES-256 encryption on S3 to prevent state corruption and data leaks.

- **Decoupled State Architecture**: Utilizing a "State-per-Service" model where every 
  infrastructure component (VPC, ALB, Compute, etc.) maintains its own independent Terraform state file.

## Coming Soon
- **IAM Governance**: Refined IAM roles using scoped execution policies
  to further harden the interaction between AWS services.

- **CloudWatch & Monitoring**: Centralized operational dashboards featuring 
  real-time metric filters and automated SNS alarms. Provides full 
  visibility into resource health across all environments.

## Tech Stack

- **Orchestration**: Terragrunt
- **IaC**: Terraform 1.x (Modules, Validation, Lifecycle Hooks)
- **Cloud**: AWS (Full Stack)
- **GitHub Actions**: Orchestration engine for CI/CD

## --- Deploying an Environment ---

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

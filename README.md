# AWS Infrastructure Modules

Reusable **Terraform** modules for secure, production-grade AWS infrastructure.  
Built with best practices: input validation, tagging, least-privilege security, and modular design.

### Current Modules

- **terraform-aws-s3-secure-bucket**  
  Secure S3 bucket module with:  
  - Strict bucket naming validation (lowercase, numbers, dots, hyphens only)  
  - Versioning enabled  
  - Server-side encryption (AES256)  
  - Public access fully blocked  
  - Optional force_destroy safety default  

- **terraform-aws-vpc** *(in progress)*  
  Modular VPC with public/private subnets, NAT, flow logs, and security groups.

- **terraform-aws-ec2-baseline** *(planned)*  
  EC2 instances with custom AMIs, security groups, and integration with Auto Scaling.

- **terraform-aws-lambda** *(planned)*  
  Serverless functions with proper IAM roles, VPC attachment, and CloudWatch alarms.

### Tech Stack
- **IaC**: Terraform (0.15+ compatible, modules, validation, locals)  
- **Cloud**: AWS (S3, VPC, EC2, IAM, Lambda, CloudWatch, Auto Scaling Groups)  

### Example Usage (S3 Module)
### --- Local Usage (Standard) ---
### Use this when calling the module from within this repository
```hcl
module "secure_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = "my-unique-bucket-name-2025"
  
  tags = {
    Environment = "prod"
    Owner       = "jermaine"
  }
  force_destroy = false
}
```

### --- Alternate Usage (Remote/HTTPS) ---
### Use this to reference the module from a different project/machine
```hcl
module "automation_assets" {
  # The double slash // is mandatory to point to the sub-folder in the repo
  source = "git::https://github.com/digital-knife/jr-tf-modules.git//modules/s3_bucket?ref=main"

  bucket_name   = "jr-automation-assets-${local.account_id}"
  force_destroy = true
  tags          = local.common_tags
}
```
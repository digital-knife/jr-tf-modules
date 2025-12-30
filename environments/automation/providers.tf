terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "jr-tf-state-automation-756148349252"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "jr-tf-state-locks"
    encrypt        = true

    # This role allows Terraform to reach the S3 Bucket/DynamoDB in the Hub (bootstrap account)
    # assume_role = {
    #   role_arn = "arn:aws:iam::756148349252:role/CrossAccountTerraformStateRole"
    # }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

# 1. Main Automation Account (The Hub)
provider "aws" {
  region  = var.aws_region
  profile = "automation-provisioner"

  # Use the provisioner role for actual work
  # assume_role {
  #   role_arn     = "arn:aws:iam::756148349252:role/automation-provisioner"
  #   session_name = "TerraformProvisioning"
  # }

  default_tags {
    tags = local.common_tags
  }
}

# 2.Management Account ONLY for Organization-level tasks or creating the Test Account.
provider "aws" {
  alias   = "management"
  region  = var.aws_region
  profile = "default" # Your original tf-demo-user keys

  allowed_account_ids = ["181651592207"]
}

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # This remains in the Automation Hub (756148349252)
    bucket         = "jr-tf-state-automation-756148349252"
    key            = "test/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "jr-tf-state-locks"
    encrypt        = true
    # Use the profile that has access to the State Bucket
    profile = "automation-provisioner"
  }
}

provider "aws" {
  region = "us-east-1"
  # Use the profile you just added for the Test Account (315735600075)
  profile = "automation-provisioner"
  assume_role {
    # This role was automatically created by AWS Organizations
    role_arn     = "arn:aws:iam::315735600075:role/OrganizationAccountAccessRole"
    session_name = "TerraformTestDeployment"
  }
  default_tags {
    tags = {
      Project     = "jr-cloud-ops"
      Environment = "test"
      ManagedBy   = "Terraform"
      Owner       = "jr-cloud-ops"
    }
  }
}

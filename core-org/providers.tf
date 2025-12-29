terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # We still store the state in the Automation Hub!
    bucket         = "jr-tf-state-automation-756148349252"
    key            = "core/org/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "jr-tf-state-locks"
    encrypt        = true
    profile        = "automation-provisioner"
  }
}

provider "aws" {
  region = "us-east-1"
  # This MUST be your Management account profile
  profile = "default" # Or whatever you named your 181... profile
}

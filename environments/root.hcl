locals {
  # Automatically load global variables
  global_vars = yamldecode(file("${get_parent_terragrunt_dir()}/_global/common_vars.yaml"))
  
  #Deployer and destination account IDs
  hub_account_id         = "756148349252" # automation-hub account ONLY BUILD FROM HERE!!!!!
  destination_account_id = "INSERT_TEST_AUTO_ID_HERE" 
}

#Store state in the Automation account
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "jr-tf-state-automation-${local.hub_account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
    
    # IMPORTANT: Use this to ensure Terragrunt uses Hub credentials for S3
    # even while the provider is assuming the Spoke role.
    s3_bucket_query_logging_enabled = true
  }
}

#Build in the Destination account
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
  
  # Only allow building in the Spoke account
  allowed_account_ids = ["${local.destination_account_id}"]

  # Reach out from the Hub and assume this role in the Spoke
  assume_role {
    role_arn = "arn:aws:iam::${local.destination_account_id}:role/TerragruntRole"
  }

  default_tags {
    tags = {
      ManagedBy   = "Terragrunt"
      Environment = "${path_relative_to_include()}"
      Project     = "${local.global_vars.project_name}"
      Owner       = "${local.global_vars.owner}"
    }
  }
}
EOF
}
locals {
  global_vars = yamldecode(file("${get_parent_terragrunt_dir()}/_global/common_vars.yaml"))
  
  hub_account_id         = "756148349252" 
  destination_account_id = "315735600075" 

  #Determine if we are deploying a Hub resource or a Spoke resource
  #We check if the folder path contains 'automation'
  is_automation_resource = contains(split("/", path_relative_to_include()), "automation")
  
  # Set the target account ID based on the folder location
  target_account_id = local.is_automation_resource ? local.hub_account_id : local.destination_account_id
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
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
  
  # Dynamically allow building in either Hub or Spoke
  allowed_account_ids = ["${local.target_account_id}"]

  # ONLY assume a role if we are NOT in an automation folder
  %{ if !local.is_automation_resource }
  assume_role {
    role_arn = "arn:aws:iam::${local.destination_account_id}:role/TerragruntRole"
  }
  %{ endif }

  default_tags {
    tags = {
      ManagedBy   = "Terragrunt"
      Environment = "${path_relative_to_include()}"
      Project     = "${local.global_vars.project_name}"
    }
  }
}
EOF
}
inputs = {
  # We extract the environment name from the folder path (e.g., "dev" or "automation")
  environment = local.is_automation_resource ? "automation" : split("/", path_relative_to_include())[1]
  
  # Pass global vars so modules can use Project/Owner tags
  project_name = local.global_vars.project_name
  owner        = local.global_vars.owner
  github_repo  = "digital-knife/jr-tf-modules"
}

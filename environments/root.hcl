locals {
  # Automatically load global variables
  global_vars = yamldecode(file("${get_parent_terragrunt_dir()}/_global/common_vars.yaml"))
}

#backend generator
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "jr-tf-state-automation-756148349252" # Change this to your bucket name
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


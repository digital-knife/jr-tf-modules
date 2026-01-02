include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/s3"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id             = "vpc-12345678"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  bucket_name = "jr-dev-data-bucket-2026" # S3 names must be globally unique!
  environment = "dev"
  versioning  = true
  force_destroy = true # Useful for dev so you can delete it even if it has files
}
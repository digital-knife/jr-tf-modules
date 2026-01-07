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
  skip_outputs = get_terraform_command() == "destroy" ? true : false
}

inputs = {
  vpc_id = try(dependency.vpc.outputs.vpc_id, try(dependency.vpc.mock_outputs.vpc_id, "vpc-dummy-id"))
  bucket_name = "jr-dev-data-bucket-2026" # S3 names must be globally unique!
  environment = "dev"
  versioning  = true
  force_destroy = true # Useful for dev so you can delete it even if it has files
}
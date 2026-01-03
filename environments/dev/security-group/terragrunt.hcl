include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id             = "vpc-12345678"
    public_subnet_ids  = ["subnet-123", "subnet-456"]
    private_subnet_ids = ["subnet-789", "subnet-012"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

terraform {
  source = "../../../modules/security-group" 
}

inputs = {
  vpc_id      = dependency.vpc.outputs.vpc_id
  environment = "dev"
  name        = "dev-bastion-sg"
}
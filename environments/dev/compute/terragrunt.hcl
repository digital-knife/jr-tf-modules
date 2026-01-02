include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id             = "vpc-12345678"
    public_subnet_ids  = ["subnet-123", "subnet-456"]
    private_subnet_ids = ["subnet-789", "subnet-012"]
    security_group_id = "sg-mock-123"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "sg" {
  config_path = "../security-group"
  mock_outputs = {
    security_group_id = "sg-mock-id-for-compute"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

terraform {
  source = "../../../modules/compute" # Update this to your Compute module path
}

inputs = {
  name          = "app-server"
  instance_type = "t3.micro"
  vpc_id        = dependency.vpc.outputs.vpc_id
  subnet_id          = dependency.vpc.outputs.public_subnet_ids[0]
  security_group_ids = [dependency.sg.outputs.security_group_id]
  instance_type      = "t3.micro"
  environment        = "dev"
}
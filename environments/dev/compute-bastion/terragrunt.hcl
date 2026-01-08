include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules//compute"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    public_subnet_ids = ["subnet-12345", "subnet-67890"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "sg" {
  config_path = "../security-group-bastion"
  mock_outputs = {
    security_group_id = "sg-mock-999"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  name          = "dev-bastion-host"
  instance_type = "t3.micro"
  
  subnet_id     = dependency.vpc.outputs.public_subnet_ids[0] 
  security_group_ids = [dependency.sg.outputs.security_group_id]
  user_data_path = "../../../modules/compute/scripts/bastion_bootstrap.sh"

  environment = "dev"

  tags = {
    Role    = "Bastion"
    Project = "JR-Rebuild"
  }
}
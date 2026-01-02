include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//compute"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    public_subnet_ids = ["subnet-11111111", "subnet-22222222"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "sg" {
  config_path = "../security-group"
  mock_outputs = {
    security_group_id = "sg-12345678"
  }
}

inputs = {
  name = "automation-bastion-host"
  instance_type = "t3.micro"
  ami = ""
  # Pick the first public subnet for external access
  subnet_id              = dependency.vpc.outputs.public_subnet_ids[0]
  security_group_ids = [dependency.sg.outputs.security_group_id]

  # bastion bootstrap script
  user_data_path = "../../../modules/compute/scripts/bastion_bootstrap.sh"

  environment = "automation"

  tags = {
    Role        = "Bastion"
    Project     = "AutomationHub"
    Environment = "production-mgmt"
  }
}
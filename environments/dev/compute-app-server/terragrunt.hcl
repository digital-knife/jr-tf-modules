include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  
  mock_outputs = {
    vpc_id             = "vpc-12345678"
    private_subnet_ids = ["subnet-789", "subnet-012"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "sg" {
  # Standardizing path to match your compute security group
  config_path = "../security-group-compute"
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  
  mock_outputs = {
    security_group_id = "sg-mock-id-for-compute"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

terraform {
  source = "../../../modules/compute"
}

inputs = {
  name                        = "app-server-private"
  instance_type               = "t3.micro"
  vpc_id                      = try(dependency.vpc.outputs.vpc_id, "vpc-dummy")
  subnet_id                   = try(dependency.vpc.outputs.private_subnet_ids[0], "subnet-dummy")
  security_group_ids          = [try(dependency.sg.outputs.security_group_id, "sg-dummy")]
  environment                 = "dev"
  associate_public_ip_address = false
}
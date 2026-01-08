include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules//security-group"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id = "vpc-12345678"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  name        = "dev-bastion-sg"
  description = "Allow SSH to Bastion from Home IP"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["70.122.10.149/32"] # Replace with your actual public IP
      description = "SSH from home"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}
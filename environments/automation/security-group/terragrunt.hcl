include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//security_group"
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc-12345678"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  vpc_id      = dependency.vpc.outputs.vpc_id
  name        = "automation-bastion-sg"
  description = "Minimalist security group for Bastion Host"
  environment = "automation"

  # Only Port 22 is allowed for bastion ssh access
  aws_vpc_security_group_ingress_rule = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["70.122.10.149/32"] #restrict to admin IP, for security best practice
      description = "SSH access for admin"
    }
  ]

  aws_vpc_security_group_egress_rule = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # Allow all outbound traffic for updates
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}
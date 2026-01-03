include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc-mock-99999"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "alb_sg" {
  config_path = "../security-group-alb"
  mock_outputs = {
    security_group_id = "sg-mock-99999"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

terraform {
  source = "../../../modules/security-group"
}

inputs = {
  name                     = "dev-compute-sg"
  description              = "Allows traffic ONLY from the ALB"
  vpc_id                   = dependency.vpc.outputs.vpc_id
  environment              = "dev"
  source_security_group_id = dependency.alb_sg.outputs.security_group_id
  create_handshake_rule    = true
}
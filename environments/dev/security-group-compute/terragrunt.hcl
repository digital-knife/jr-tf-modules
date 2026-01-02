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

dependency "alb_sg" {
  config_path = "../security-group-alb"
  mock_outputs = {
    security_group_id = "sg-mock-id"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

terraform {
  source = "../../../modules/security-group"
}

inputs = {
  name        = "dev-compute-sg"
  description = "Allows traffic ONLY from the ALB"
  vpc_id      = dependency.vpc.outputs.vpc_id
  environment = "dev"

  ingress_rules = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      # INDUSTRY STANDARD: Chaining by SG ID, not IP!
      source_security_group_id = dependency.alb_sg.outputs.security_group_id
      description              = "Allow traffic from ALB only"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
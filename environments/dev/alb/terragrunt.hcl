include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/alb"
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
    security_group_id = "sg-alb-mock"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  name               = "dev-web-alb"
  environment        = "dev"
  load_balancer_type = "application"
  vpc_id             = dependency.vpc.outputs.vpc_id
  
  # Aligned to your module's variables.tf
  public_subnet_ids  = dependency.vpc.outputs.public_subnet_ids
  security_group_ids = [dependency.alb_sg.outputs.security_group_id]
  
  # Defaults for the listener
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}
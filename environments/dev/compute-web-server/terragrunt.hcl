include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id            = "vpc-12345678"
    public_subnet_ids = ["subnet-123", "subnet-456"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "sg" {
  config_path = "../security-group-compute"
  mock_outputs = {
    security_group_id = "sg-mock-id-for-compute"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "alb" {
  config_path = "../alb" # Adjust path to your ALB folder
  mock_outputs = {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123:targetgroup/mock/123"
  }
}

terraform {
  source = "../../../modules//compute"
}

inputs = {
  name                        = "web-server-public"
  instance_type               = "t3.micro"
  vpc_id                      = dependency.vpc.outputs.vpc_id
  subnet_id                   = dependency.vpc.outputs.public_subnet_ids[0]
  security_group_ids          = [dependency.sg.outputs.security_group_id]
  target_group_arn            = dependency.alb.outputs.target_group_arn
  environment                 = "dev"
  associate_public_ip_address = true
  user_data_path              = "../../../modules/compute/scripts/web_bootstrap.sh"
}
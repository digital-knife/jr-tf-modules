include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
  # Logic: Prevent parser hang during destroy
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  
  mock_outputs = {
    vpc_id            = "vpc-12345678"
    public_subnet_ids = ["subnet-123", "subnet-456"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "sg" {
  config_path = "../security-group-compute"
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  
  mock_outputs = {
    security_group_id = "sg-mock-id-for-compute"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "alb" {
  config_path = "../alb"
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  
  mock_outputs = {
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123:targetgroup/mock/123"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

terraform {
  source = "../../../modules//compute"
}

inputs = {
  name                        = "web-server-public"
  instance_type               = "t3.micro"
  vpc_id                      = try(dependency.vpc.outputs.vpc_id, "vpc-dummy")
  subnet_id                   = try(dependency.vpc.outputs.public_subnet_ids[0], "subnet-dummy")
  security_group_ids          = [try(dependency.sg.outputs.security_group_id, "sg-dummy")]
  target_group_arn            = try(dependency.alb.outputs.target_group_arn, null)
  environment                 = "dev"
  associate_public_ip_address = true
  user_data_path              = "../../../modules/compute/scripts/web_bootstrap.sh"
}
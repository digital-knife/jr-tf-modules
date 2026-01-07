include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  mock_outputs = {
    vpc_id = "vpc-mock-99999"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

terraform {
  source = "../../../modules/security-group"
}

inputs = {
  name                = "dev-alb-sg"
  description         = "Allows public web traffic to the ALB"
  vpc_id              = try(dependency.vpc.outputs.vpc_id, "vpc-dummy-id")
  environment         = "dev"
  public_ingress_port = 80
}
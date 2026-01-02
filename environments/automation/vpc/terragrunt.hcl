include "root" {
  path = find_in_parent_folders()
}

terraform {
  # Pointing to your existing industry-standard VPC module
  source = "../../../modules//vpc"
}

inputs = {
  aws_vpc            = "automation-hub-vpc"
  vpc_cidr           = "10.10.0.0/16"
  public_subnet_ips  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_ips = ["10.10.10.0/24", "10.10.11.0/24"]
  azs                = ["us-east-1a", "us-east-1b"]
  environment        = "automation"

  #dont need nat gateway for automation hub
  enable_nat_gateway = false
  single_nat_gateway = false

  tags = {
    Environment = "automation"
    ManagedBy   = "terragrunt"
  }
}
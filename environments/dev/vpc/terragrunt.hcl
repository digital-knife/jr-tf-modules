include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Point this to your local module path
  source = "../../../modules/vpc"
}

inputs = {
  vpc_name           = "dev-vpc"
  vpc_cidr           = "10.20.0.0/16" # Different CIDR than automation
  environment        = "dev"
  az_count           = 2
  enable_nat_gateway = true
}
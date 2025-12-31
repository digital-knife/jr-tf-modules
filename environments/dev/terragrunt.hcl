include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_cidr             = "10.0.0.0/16"
  environment          = "dev"
  instance_type        = "t3.micro"
  # Add any other variables your modules require here
}
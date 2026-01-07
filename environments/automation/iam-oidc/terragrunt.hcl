include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules//iam-oidc"
}

inputs = {
  environment = "automation"
  github_repo = "digital-knife/jr-tf-modules"
  role_name   = "automation-github-actions-role"
}
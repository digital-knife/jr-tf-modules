include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules//s3" # Pointing to your existing S3 module
}

inputs = {
  bucket_name = "jr-demo-bucket-2026-for-github-actions-testing"
  environment = "dev"

  tags = {
    Demo = "true"
    Purpose = "GitHub-Actions-Proof"
  }
}
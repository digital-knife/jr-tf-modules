#data sources
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# standardize local map for tags
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "jr-cloud-ops"
  }
}

module "automation_assets" {
  source = "./modules/s3_bucket"

  # Using your existing local to ensure global uniqueness
  bucket_name   = "jr-automation-assets-${local.account_id}"
  force_destroy = true

  # Merging your common_tags with module-specific tags
  tags = merge(
    local.common_tags,
    {
      Name = "Automation Assets Bucket"
    }
  )
}

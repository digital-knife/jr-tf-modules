# This creates the AWS Organization itself
resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

# The Automation Hub Account (756148349252)
resource "aws_organizations_account" "automation" {
  name      = "automation"
  email     = var.automation_account_email
  role_name = "OrganizationAccountAccessRole"

  # Professional practice: prevent Terraform from trying to 
  # recreate/change the role name after the account is born.
  lifecycle {
    ignore_changes = [role_name]
  }

  tags = local.common_tags
}

# The Test Account (315735600075)
resource "aws_organizations_account" "test" {
  name      = "jr-test-automation1"
  email     = var.test_account_email # Ensure this variable exists in variables.tf
  role_name = "OrganizationAccountAccessRole"

  lifecycle {
    ignore_changes = [role_name]
  }

  tags = local.common_tags
}

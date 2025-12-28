#Create Automation account
resource "aws_organizations_account" "automation" {
  provider = aws.management
  name     = "automation"
  email    = var.automation_account_email

  #Assume admin role in new account
  role_name = "OrganizationAccountAccessRole"

  #Prevent accidental deletion
  lifecycle {
    ignore_changes = [role_name]
  }

  tags = local.common_tags
}

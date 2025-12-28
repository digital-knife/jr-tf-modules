output "current_region" {
  description = "The AWS region in which resources are created"
  value       = var.aws_region
}

output "project_environment" {
  description = "The deployment environment for the project"
  value       = var.environment
}

output "management_account_id" {
  description = "The AWS Account ID of the management account"
  value       = data.aws_caller_identity.current.account_id
}

output "automation_account_id" {
  description = "The AWS Account ID of the automation account"
  value       = aws_organizations_account.automation.id
}

output "automation_account_arn" {
  description = "The ARN of the automation AWS account"
  value       = aws_organizations_account.automation.arn
}

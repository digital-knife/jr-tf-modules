output "automation_account_id" {
  value = aws_organizations_account.automation.id
}

output "test_account_id" {
  value = aws_organizations_account.test.id
}

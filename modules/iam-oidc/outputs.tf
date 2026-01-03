output "role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "The ARN of the IAM Role for GitHub Actions to assume"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github.arn
  description = "The ARN of the OIDC Provider"
}

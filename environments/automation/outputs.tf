output "automation_bucket_name" {
  description = "The name of the bucket in the automation account"
  value       = module.automation_assets.bucket_id
}

output "automation_bucket_arn" {
  description = "The ARN of the bucket in the automation account"
  value       = module.automation_assets.bucket_arn
}

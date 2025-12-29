output "test_bucket_name" {
  description = "The name of the bucket created in the test account"
  # This points to the module's output we just discussed
  value = module.test_assets.bucket_id
}

output "test_bucket_arn" {
  description = "The ARN of the bucket created in the test account"
  value       = module.test_assets.bucket_arn
}
output "test_bucket_domain_name" {
  description = "The domain name of the bucket created in the test account"
  value       = module.test_assets.bucket_domain_name
}

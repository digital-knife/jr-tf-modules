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

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnet_ids
}

output "private_subnets" {
  value = module.network.private_subnet_ids
}

output "nat_ips" {
  value = module.network.nat_public_ips
}

output "server_details" {
  description = "Detailed map of all deployed instances"
  value = {
    for k, v in module.app_server : k => {
      private_ip = v.private_ip
      az         = v.instance_availability_zone
      state      = v.instance_state
    }
  }
}

output "load_balancer_url" {
  description = "The public URL to access your application"
  # This works here because 'main_alb' is a module call in this same directory
  value = "http://${module.main_alb.alb_dns_name}"
}

output "instance_private_ips" {
  description = "Private IPs of the deployed fleet for internal verification"
  # This works here because 'app_server' is a module call in this same directory
  value = { for k, v in module.app_server : k => v.private_ip }
}

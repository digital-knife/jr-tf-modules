output "security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "The ARN of the created security group"
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "The name of the created security group"
  value       = aws_security_group.this.name
}

output "egress_rule_id" {
  description = "The ID of the egress rule allowing all outbound traffic"
  value       = aws_security_group_rule.allow_all_egress.id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "The ID of the Public Route Table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "The IDs of the Private Route Tables"
  value       = aws_route_table.private[*].id
}

#OPTIONAL RESOURCE OUTPUTS

output "nat_public_ips" {
  description = "The public IPs of the NAT Gateways (Empty list if disabled)"
  value       = aws_eip.nat[*].public_ip
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT Gateways (Empty list if disabled)"
  value       = aws_nat_gateway.this[*].id
}
output "aws_vpc" {
  description = "The VPC resource"
  value       = aws_vpc.this
}

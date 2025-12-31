resource "aws_security_group" "this" {
  name        = "${var.environment}-${var.name}-sg"
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-${var.name}-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# --- Outbound Rules ---
resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
}

# --- Inbound Rules (Dynamic based on variables) ---

# This handles the ALB (Internet -> SG)
resource "aws_vpc_security_group_ingress_rule" "public_http" {
  for_each = var.public_ingress_port != null ? toset([tostring(var.public_ingress_port)]) : toset([])

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.public_ingress_port
  to_port           = var.public_ingress_port
  ip_protocol       = "tcp"
  description       = "Allow public HTTP traffic"
}

# This handles the Handshake (ALB SG -> App SG)
resource "aws_vpc_security_group_ingress_rule" "app_from_source_sg" {
  count = var.create_handshake_rule ? 1 : 0

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.source_security_group_id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "Allow traffic from source security group"
}

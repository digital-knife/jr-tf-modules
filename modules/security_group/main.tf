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

# Industry Standard: Explicit, Standalone Outbound Rule
resource "aws_security_group_rule" "allow_all_egress" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # All protocols
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

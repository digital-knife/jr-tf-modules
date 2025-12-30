# 1. The Load Balancer
resource "aws_lb" "this" {
  name               = "${var.name}-${var.environment}-alb"
  internal           = false # Set to false because it's in public subnets for external traffic
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false # Set to true in production environments. false is ok for test envs

  tags = {
    Name        = "${var.name}-${var.environment}-alb"
    Environment = var.environment
  }
}

# 2. The Target Group
resource "aws_lb_target_group" "this" {
  name     = "${var.name}-${var.environment}-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  # Crucial for EC2 instances
  target_type = "instance"

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    matcher             = "200" # Expect a success code from the app
  }

  tags = {
    Name        = "${var.name}-${var.environment}-tg"
    Environment = var.environment
  }
}

# 3. The Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# 4. Target Attachments
resource "aws_lb_target_group_attachment" "this" {
  for_each         = toset(var.target_ids)
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value
  port             = var.target_group_port
}

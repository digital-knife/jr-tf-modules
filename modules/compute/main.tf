# Fetch the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#Attach EC2 Instance to ALB Target Group
resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.this.id
  port             = 80
}

# 2. IAM Role for SSM Access
resource "aws_iam_role" "this" {
  name = "${var.environment}-${var.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "${var.environment}-${var.name}-ssm-role"
    Environment = var.environment
  }
}

# Attach the standard SSM policy to the role
resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# The Instance Profile (The "bridge" between the Role and the EC2 Instance)
resource "aws_iam_instance_profile" "this" {
  name = "${var.environment}-${var.name}-instance-profile"
  role = aws_iam_role.this.name
}

# 3. The EC2 Instance
resource "aws_instance" "this" {
  ami                         = var.ami != null ? var.ami : data.aws_ami.amazon_linux_2023.id
  user_data                   = file("${path.module}/scripts/install_nginx.sh")
  user_data_replace_on_change = true
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = aws_iam_instance_profile.this.name

  # Security Best Practice: Enforce IMDSv2 (prevents credential theft)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name        = "${var.name}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

locals {
  # Define your fleet as a map
  # Key = unique identifier, Value = configuration
  server_fleet = {
    "web-01" = { type = "t3.micro" }
    "app-01" = { type = "t3.small" }
  }
}

module "network" {
  source      = "../modules/vpc"
  environment = "test"
  vpc_cidr    = "10.1.0.0/16"
  az_count    = 2
}

module "test_assets" {
  #relative path to reach back into modules folder
  source      = "../modules/s3_bucket"
  bucket_name = "jr-test-assets-315735600075"
}

module "app_sg" {
  source      = "../modules/security_group"
  name        = "app-server"
  description = "Security group for application servers"
  vpc_id      = module.network.vpc_id
  environment = "test"
}

module "app_server" {
  source   = "../modules/compute"
  for_each = local.server_fleet

  # Access the key ("web-01", etc.) and the value (type)
  name          = each.key
  instance_type = each.value.type
  environment   = "test"
  ami           = data.aws_ami.amazon_linux_2023.id # Amazon Linux 2023 AMI (us-east-1)

  # We convert our map keys to a list to get a stable index for subnet rotation
  subnet_id = element(
    module.network.private_subnet_ids,
    index(keys(local.server_fleet), each.key)
  )

  security_group_ids = [module.app_sg.security_group_id]
}

#Create the Security Group for the ALB
module "alb_sg" {
  source      = "../modules/security_group"
  name        = "main-alb-sg"
  environment = "test"
  vpc_id      = module.network.vpc_id
}

#Deploy the ALB
module "main_alb" {
  source             = "../modules/alb"
  name               = "web-app"
  environment        = "test"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  security_group_ids = [module.alb_sg.security_group_id]

  # pulls IDs from the map created by 'for_each' in the server module
  target_ids = [for s in module.app_server : s.instance_id]
}


# RULE A: Allow the Internet (0.0.0.0/0) to talk to the ALB on Port 80
resource "aws_vpc_security_group_ingress_rule" "alb_http_inbound" {
  security_group_id = module.alb_sg.security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow public HTTP traffic to ALB"
}

# RULE B: Allow the ALB to talk to the App Servers
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = module.app_sg.security_group_id # The server's SG
  referenced_security_group_id = module.alb_sg.security_group_id # The source is the ALB
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "Allow traffic only from the ALB"
}

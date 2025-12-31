# --- Data Sources ---
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# --- Local Variables ---
locals {
  server_fleet = {
    "web-01" = { type = "t3.micro" }
    "app-01" = { type = "t3.small" }
  }
}

# --- 1. Network Layer ---
module "network" {
  source      = "../../modules/vpc"
  environment = "test"
  vpc_cidr    = "10.1.0.0/16"
  az_count    = 2
}

# --- 2. Security Layer ---

# ALB Security Group: Open to the public on Port 80
module "alb_sg" {
  source              = "../../modules/security_group"
  name                = "main-alb-sg"
  vpc_id              = module.network.vpc_id
  environment         = "test"
  public_ingress_port = 80
}

# App Security Group: Only allows traffic from the ALB Security Group
module "app_sg" {
  source                   = "../../modules/security_group"
  name                     = "app-server-sg"
  vpc_id                   = module.network.vpc_id
  environment              = "test"
  create_handshake_rule    = true                            # known at plan
  source_security_group_id = module.alb_sg.security_group_id # known at apply
}

# --- 3. Storage & Assets ---
module "test_assets" {
  source      = "../../modules/s3_bucket"
  bucket_name = "jr-test-assets-315735600075"
}

# --- 4. Compute Layer ---
module "app_server" {
  source   = "../../modules/compute"
  for_each = local.server_fleet

  name          = each.key
  instance_type = each.value.type
  environment   = "test"
  ami           = data.aws_ami.amazon_linux_2023.id

  # Rotates subnets based on the index of the map key
  subnet_id = element(
    module.network.private_subnet_ids,
    index(keys(local.server_fleet), each.key)
  )

  security_group_ids = [module.app_sg.security_group_id]
}

# --- 5. Load Balancing Layer ---
module "main_alb" {
  source             = "../../modules/alb"
  name               = "web-app"
  environment        = "test"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  security_group_ids = [module.alb_sg.security_group_id]

  # Dynamic list of all instance IDs generated in the compute module
  target_instances = module.app_server
}

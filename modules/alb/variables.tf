variable "name" {
  type        = string
  description = "Name of the load balancer"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. test, prod)"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the ALB and Target Group will reside"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups to attach to the ALB"
}

# --- Target Group Settings ---

variable "target_group_port" {
  type    = number
  default = 80
}

variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}

# --- Health Check Settings ---

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_interval" {
  type    = number
  default = 30
}

variable "health_check_timeout" {
  type    = number
  default = 5
}

variable "healthy_threshold" {
  type    = number
  default = 3
}

variable "unhealthy_threshold" {
  type    = number
  default = 3
}

# --- Listener Settings ---

variable "listener_port" {
  type    = number
  default = 80
}

variable "listener_protocol" {
  type    = string
  default = "HTTP"
}

# --- Target Management ---

variable "target_instances" {
  type        = any
  description = "List of EC2 Instance IDs to attach to the Target Group"
  default     = {}
}


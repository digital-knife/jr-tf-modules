variable "name" {
  type        = string
  description = "The name of the EC2 instance"
}

variable "environment" {
  type        = string
  description = "The environment of the EC2 instance (e.g., dev, test, prod)"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The type of the EC2 instance"
}

variable "subnet_id" {
  type        = string
  description = "The private subnet ID where the instance will live"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of SG IDs to attach to the instance"
}

variable "ami" {
  type        = string
  description = "The AMI ID to use for the EC2 instance"
  default     = null
}

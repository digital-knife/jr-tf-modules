variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "environment" {
  description = "The environment for the VPC (e.g., dev, prod)."
  type        = string
}

variable "az_count" {
  description = "The number of availability zones to use."
  type        = number
  default     = 2
}

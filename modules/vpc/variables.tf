variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "environment" {
  description = "The environment name (used for resource naming and tagging)."
  type        = string
}

variable "az_count" {
  description = "Number of AZs to distribute subnets across."
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = "Toggle to create NAT Gateways and associated EIPs. Set to false to save costs."
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "If true, will create one NAT Gateway shared by all private subnets."
  type        = bool
  default     = false
}

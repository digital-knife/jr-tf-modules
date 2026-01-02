variable "name" {
  type        = string
  description = "The name of the security group"
}

variable "description" {
  type        = string
  description = "The description of the security group"
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "environment" {
  type        = string
  description = "Environment name (test/prod)"
}

variable "source_security_group_id" {
  description = "Optional: ID of a remote SG to allow traffic from"
  type        = string
  default     = null # Making it null allows the module to work without it
}

variable "public_ingress_port" {
  description = "Optional: Port to open to the public (0.0.0.0/0)"
  type        = number
  default     = null
}

variable "create_handshake_rule" {
  description = "Whether to create the ingress rule for the source SG"
  type        = bool
  default     = false
}

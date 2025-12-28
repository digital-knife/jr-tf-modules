variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "jr-cloud-ops"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "management"
}

variable "automation_account_email" {
  description = "The email address for the automation AWS account"
  type        = string
  default     = "jrakoczy1automation@gmail.com"
}

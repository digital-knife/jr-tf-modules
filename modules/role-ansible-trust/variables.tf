variable "automation_account_id" {
  type        = string
  description = "The 12-digit AWS Account ID of the Automation account that will manage this environment."
}

variable "environment" {
  type        = string
  description = "The environment name (e.g., dev, prod) for tagging."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to the IAM role."
  default     = {}
}

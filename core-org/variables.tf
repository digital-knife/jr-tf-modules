variable "automation_account_email" {
  type        = string
  description = "email for the Automation Hub account"
  default     = "jrakoczy1automation@gmail.com"
}

variable "test_account_email" {
  type        = string
  description = "email for the Test account"
  default     = "jr-test-automation1@protonmail.com"
}

variable "project_name" {
  type    = string
  default = "jr-cloud-ops"
}

variable "environment" {
  type    = string
  default = "org-core"
}

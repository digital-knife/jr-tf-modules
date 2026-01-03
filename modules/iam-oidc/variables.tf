variable "environment" {
  type        = string
  description = "The environment name (e.g., automation, dev)"
}

variable "github_repo" {
  type        = string
  description = "The GitHub organization/repository name (e.g., digital-knife/jr-tf-modules)"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging"
}

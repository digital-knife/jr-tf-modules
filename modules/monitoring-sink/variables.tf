variable "sink_name" {
  description = "Name of the OAM Sink"
  type        = string
  default     = "Central-Monitoring-Sink"
}

variable "allowed_account_ids" {
  description = "List of AWS Account IDs allowed to link to this sink"
  type        = list(string)
}

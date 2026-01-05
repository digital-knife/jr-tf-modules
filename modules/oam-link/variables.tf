variable "sink_arn" {
  type        = string
  description = "The ARN of the central Sink in the Automation account."
}

variable "label_template" {
  type        = string
  default     = "$AccountName"
  description = "How the source account appears in the monitoring dashboard."
}

variable "resource_types" {
  type        = list(string)
  default     = ["AWS::CloudWatch::Metric", "AWS::Logs::LogGroup"]
  description = "The types of data to share (Metrics, Logs, Traces)."
}

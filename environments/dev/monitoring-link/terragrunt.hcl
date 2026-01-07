include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/oam-link"
}

dependency "monitoring_sink" {
  config_path = "../../automation/monitoring-sink"
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  mock_outputs = {
    sink_arn = "arn:aws:oam:us-east-1:123456789012:sink/mock-id"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  sink_arn = try(dependency.monitoring_sink.outputs.sink_arn, "arn:aws:oam:us-east-1:123456789012:sink/dummy")
  label_template = "$AccountName"
  resource_types = ["AWS::CloudWatch::Metric", "AWS::Logs::LogGroup"]
}
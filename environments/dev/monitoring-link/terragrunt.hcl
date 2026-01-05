include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # The "How": Point to your new central module
  source = "../../../modules/oam-link"
}

inputs = {
  sink_arn = "arn:aws:oam:us-east-1:756148349252:sink/093166cc-9f71-43d2-a26e-2fb88092bcc5"
  label_template = "$AccountName"
  resource_types = ["AWS::CloudWatch::Metric", "AWS::Logs::LogGroup"]
}
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# We leave this empty because we are using the local main.tf in this folder
terraform {}

inputs = {
  # These names MUST match the 'variable' names in your main.tf exactly
  sink_name = "central-observability-sink"
  
  sink_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["oam:CreateLink", "oam:UpdateLink"]
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          # Ensure this is your actual DEV Account ID
          AWS = "arn:aws:iam::315735600075:root" 
        }
        Condition = {
          "ForAllValues:StringEquals" = {
            "oam:ResourceTypes" = ["AWS::CloudWatch::Metric", "AWS::Logs::LogGroup"]
          }
        }
      }
    ]
  })
}
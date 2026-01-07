resource "aws_oam_sink" "this" {
  name = var.sink_name
}

resource "aws_oam_sink_policy" "this" {
  sink_identifier = aws_oam_sink.this.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["oam:CreateLink", "oam:UpdateLink"]
      Effect   = "Allow"
      Resource = "*"
      #Use an explicit Principal map
      Principal = {
        AWS = var.allowed_account_ids
      }
      Condition = {
        "ForAllValues:StringEquals" = {
          "oam:ResourceTypes" = ["AWS::CloudWatch::Metric", "AWS::Logs::LogGroup"]
        }
      }
    }]
  })
}

output "sink_arn" { value = aws_oam_sink.this.arn }

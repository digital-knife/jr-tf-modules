resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = var.dashboard_name
  dashboard_body = var.dashboard_body
}

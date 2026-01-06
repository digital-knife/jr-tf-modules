include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules//cloudwatch-dashboard"
}

dependency "web_server" {
  config_path = "../compute-web-server"
}

dependency "app_server" {
  config_path = "../compute-app-server"
}

inputs = {
  dashboard_name = "JR-Dev-Infrastructure-Monitoring"
  
  dashboard_body = jsonencode({
    widgets = [
      # --- ROW 1: CPU UTILIZATION (FREE TIER) ---
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", dependency.web_server.outputs.instance_id]
          ],
          period = 300,
          stat   = "Average",
          region = "us-east-1",
          title  = "Web Server CPU (%)"
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", dependency.app_server.outputs.instance_id]
          ],
          period = 300,
          stat   = "Average",
          region = "us-east-1",
          title  = "App Server CPU (%)"
        }
      },
      # --- ROW 2: DISK USAGE (AGENT METRIC) ---
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", dependency.web_server.outputs.instance_id, "device", "xvda1", "fstype", "xfs", "path", "/"]
          ],
          period = 300,
          stat   = "Average",
          region = "us-east-1",
          title  = "Web Server Disk Usage (%)"
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", dependency.app_server.outputs.instance_id, "device", "xvda1", "fstype", "xfs", "path", "/"]
          ],
          period = 300,
          stat   = "Average",
          region = "us-east-1",
          title  = "App Server Disk Usage (%)"
        }
      }
    ]
  })
}
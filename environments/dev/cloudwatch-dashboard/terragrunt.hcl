include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules//cloudwatch-dashboard"
}

dependency "web_server" {
  config_path = "../compute-web-server"
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  
  mock_outputs = {
    instance_id = "i-mock12345"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

dependency "app_server" {
  config_path = "../compute-app-server"
  skip_outputs = get_terraform_command() == "destroy" ? true : false
  
  mock_outputs = {
    instance_id = "i-mock67890"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  dashboard_name = "JR-Dev-Infrastructure-Monitoring"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            # USE try() HERE to prevent parser crashes
            ["AWS/EC2", "CPUUtilization", "InstanceId", try(dependency.web_server.outputs.instance_id, "i-dummy")]
          ],
          period = 300, stat = "Average", region = "us-east-1",
          title  = "Web Server CPU (%)"
        }
      },
      {
        type   = "metric",
        x      = 12, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", try(dependency.app_server.outputs.instance_id, "i-dummy")]
          ],
          period = 300, stat = "Average", region = "us-east-1",
          title  = "App Server CPU (%)"
        }
      },
      {
        type   = "metric",
        x      = 0, y = 6, width = 12, height = 6,
        properties = {
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", try(dependency.web_server.outputs.instance_id, "i-dummy"), "device", "xvda1", "fstype", "xfs", "path", "/"]
          ],
          period = 300, stat = "Average", region = "us-east-1",
          title  = "Web Server Disk Usage (%)"
        }
      },
      {
        type   = "metric",
        x      = 12, y = 6, width = 12, height = 6,
        properties = {
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", try(dependency.app_server.outputs.instance_id, "i-dummy"), "device", "xvda1", "fstype", "xfs", "path", "/"]
          ],
          period = 300, stat = "Average", region = "us-east-1",
          title  = "App Server Disk Usage (%)"
        }
      }
    ]
  })
}
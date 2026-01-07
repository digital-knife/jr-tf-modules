include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules//cloudwatch-dashboard"
}

# Dependencies remain for ordering
dependency "web_server" { config_path = "../../dev/compute-web-server" }
dependency "app_server" { config_path = "../../dev/compute-app-server" }

inputs = {
  dashboard_name = "GLOBAL-OPERATIONS-CENTER"
  
  dashboard_body = jsonencode({
    widgets = [
      # --- ROW 1: CPU ---
      {
        type = "metric", x = 0, y = 0, width = 12, height = 6,
        properties = {
          metrics = [[ { "expression": "SEARCH('{AWS/EC2,InstanceId} MetricName=\"CPUUtilization\"', 'Average', 300)", "id": "cpu" } ]],
          region = "us-east-1", title = "Global: CPU Utilization (%)"
        }
      },
      # --- ROW 2: NETWORK ---
      {
        type = "metric", x = 12, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            [ { "expression": "SEARCH('{AWS/EC2,InstanceId} MetricName=\"NetworkIn\"', 'Average', 300)", "id": "ni" } ],
            [ { "expression": "SEARCH('{AWS/EC2,InstanceId} MetricName=\"NetworkOut\"', 'Average', 300)", "id": "no" } ]
          ],
          region = "us-east-1", title = "Global: Network In/Out (Bytes)"
        }
      },
      # --- ROW 3: ALB HEALTH (The "Front Door") ---
      {
        type = "metric", x = 0, y = 6, width = 12, height = 6,
        properties = {
          metrics = [
            [ { "expression": "SEARCH('{AWS/ApplicationELB,TargetGroup,LoadBalancer} MetricName=\"HealthyHostCount\"', 'Average', 300)", "id": "healthy" } ],
            [ { "expression": "SEARCH('{AWS/ApplicationELB,TargetGroup,LoadBalancer} MetricName=\"UnHealthyHostCount\"', 'Average', 300)", "id": "unhealthy" } ]
          ],
          region = "us-east-1", title = "ALB: Healthy vs Unhealthy Hosts",
          yAxis = { left = { min = 0 } }
        }
      },
      # --- ROW 4: EBS DISK I/O (Storage Performance) ---
      {
        type = "metric", x = 12, y = 6, width = 12, height = 6,
        properties = {
          metrics = [
            [ { "expression": "SEARCH('{AWS/EC2,InstanceId} MetricName=\"EBSReadBytes\"', 'Average', 300)", "id": "read" } ],
            [ { "expression": "SEARCH('{AWS/EC2,InstanceId} MetricName=\"EBSWriteBytes\"', 'Average', 300)", "id": "write" } ]
          ],
          region = "us-east-1", title = "Global: Disk I/O (EBS Read/Write Bytes)"
        }
      },
      # --- ROW 5: STATUS CHECKS (Health) ---
      {
        type = "metric", x = 0, y = 12, width = 24, height = 6,
        properties = {
          metrics = [[ { "expression": "SEARCH('{AWS/EC2,InstanceId} MetricName=\"StatusCheckFailed\"', 'Maximum', 300)", "id": "health" } ]],
          region = "us-east-1", title = "Global Health: Status Check Failures",
          yAxis = { left = { min = 0, max = 1 } }
        }
      }
    ]
  })
}
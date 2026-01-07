include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}//modules/monitoring-sink"
}

locals {
  common_vars = yamldecode(file("../../_global/common_vars.yaml"))
}

inputs = {
  sink_name = "Central-Monitoring-Sink"
  allowed_account_ids = [
    local.common_vars.dev_account_id
  ]
}
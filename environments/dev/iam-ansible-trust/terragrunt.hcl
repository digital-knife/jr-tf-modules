include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/role-ansible-trust"
}

inputs = {
  automation_account_id = "756148349252" 
}
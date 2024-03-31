locals {
  common_vars = read_terragrunt_config("${get_path_to_repo_root()}//terragrunt/base/common.hcl")

  env                 = local.common_vars.locals.env
  region              = local.common_vars.locals.region
  private_domain_name = local.common_vars.locals.private_domain_name
}

# Include all settings from the root terragrunt.hcl file (backend herited here)
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}//opentofu/modules/network"
}

inputs = {
  env                          = local.env
  region                       = local.region
  private_domain_name          = local.private_domain_name
  tailscale_subnet_router_name = "ogenki"
  tailscale_tailnet_name       = "smainklh@gmail.com"
}


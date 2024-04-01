locals {
  common_vars = read_terragrunt_config("${get_path_to_repo_root()}//terragrunt/base/common.hcl")

  env          = local.common_vars.locals.env
  cluster_name = "controlplane-0"
}

# Include all settings from the root terragrunt.hcl file (backend herited here)
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_path_to_repo_root()}//opentofu/modules/eks"
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  env          = local.env
  cluster_name = local.cluster_name

  vpc_id                      = dependency.network.outputs.vpc_id
  vpc_cidr_block              = dependency.network.outputs.vpc_cidr_block
  private_subnets_ids         = dependency.network.outputs.private_subnets
  intra_subnets_ids           = dependency.network.outputs.intra_subnets
  tailscale_security_group_id = dependency.network.outputs.tailscale_security_group_id

  github_owner      = "Smana"
  github_repository = "demo-tofu-controller"
  github_branch     = "dummy" # Change the branch to the one tested
}


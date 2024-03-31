# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  common_vars = read_terragrunt_config("${get_path_to_repo_root()}//terragrunt/base/common.hcl")

  account_id   = local.common_vars.locals.account_id
  account_name = local.common_vars.locals.account_name
  region       = local.common_vars.locals.region
  default_tags = local.common_vars.locals.tags

}

# Generate an AWS provider block
generate "provider-aws" {
  path      = "provider-aws.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  default_tags {
    tags = ${jsonencode(local.default_tags)}
  }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "demo-smana-remote-backend"
    key            = "${get_path_to_repo_root()}/${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {
  before_hook "tfsec" {
    commands = ["plan", "apply"]
    execute = [
      "tfsec", ".", "--config-file", "tfsec.yaml"
    ]
  }

  # before_hook "tflint" {
  #   commands = ["plan"]
  #   execute = [
  #     "tflint", "--init", "--color", "--config", "${find_in_parent_folders(".tflint.hcl")}"
  #   ]
  # }

  # before_hook "tflint" {
  #   commands = ["plan"]
  #   execute = [
  #     "tflint", ".", "--color", "--config", "${find_in_parent_folders(".tflint.hcl")}"
  #   ]
  # }
}

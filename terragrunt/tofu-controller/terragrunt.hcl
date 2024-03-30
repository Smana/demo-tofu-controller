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
  source = "tfr:///terraform-aws-modules/eks-pod-identity/aws?version=1.1.0"
}

dependency "eks" {
  config_path = "../eks"
}

# Create the secret used by the branch planner (Github token).
generate "github_token" {
  path      = "tofu-controller-github-token.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${dependency.eks.outputs.cluster_name}"
}

provider "kubernetes" {
  host                   = "${dependency.eks.outputs.cluster_endpoint}"
  cluster_ca_certificate = base64decode("${dependency.eks.outputs.cluster_certificate_authority_data}")
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

data "aws_secretsmanager_secret" "tf_controller_branch_planner_token" {
  name = "github/tofu-controller-github-token"
}

data "aws_secretsmanager_secret_version" "tf_controller_branch_planner_token" {
  secret_id = data.aws_secretsmanager_secret.tf_controller_branch_planner_token.id
}

resource "kubernetes_secret" "tf_controller_branch_planner_token" {
  metadata {
    name      = "branch-planner-token"
    namespace = "flux-system"
    labels = {
      managed-by = "opentofu"
    }
  }

  data = {
    "token" = jsondecode(data.aws_secretsmanager_secret_version.tf_controller_branch_planner_token.secret_string)["github-token"]
  }
}
EOF
}

inputs = {
  name = "tofu-controller"

  additional_policy_arns = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  associations = {
    tofu-controller = {
      cluster_name    = dependency.eks.outputs.cluster_name
      namespace       = "flux-system"
      service_account = "tf-runner"
    }
  }

}


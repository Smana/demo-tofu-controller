data "aws_caller_identity" "this" {}

# tflint-ignore: terraform_unused_declarations
data "aws_ecr_authorization_token" "token" {}

#tflint-ignore: terraform_unused_declarations
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = var.github_token_secretsmanager_name
}

data "http" "gateway_api_crds" {
  count = length(local.gateway_api_crds_urls)
  url   = local.gateway_api_crds_urls[count.index]
}

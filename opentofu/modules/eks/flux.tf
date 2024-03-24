resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = var.github_repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.this]

  path = "clusters/${var.cluster_name}"
}

resource "kubernetes_config_map" "flux_clusters_vars" {
  metadata {
    name      = "eks-${var.cluster_name}-vars"
    namespace = "flux-system"
  }

  data = {
    cluster_name      = var.cluster_name
    oidc_provider_arn = module.eks.oidc_provider_arn
    aws_account_id    = data.aws_caller_identity.this.account_id
    region            = var.region
    environment       = var.env
    vpc_id            = var.vpc_id
  }
  depends_on = [flux_bootstrap_git.this]
}

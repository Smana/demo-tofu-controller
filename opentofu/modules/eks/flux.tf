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
  path = "clusters/${var.cluster_name}"

  depends_on = [
    github_repository_deploy_key.this,
    helm_release.cilium
  ]
}

# Write a ConfigMap for use with Flux's variable substitutions
# Creating it before Flux bootstrap in order to speed up the first reconciliation
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }
  depends_on = [module.eks]
}

resource "kubernetes_config_map" "flux_clusters_vars" {
  metadata {
    name      = "eks-${var.cluster_name}-vars"
    namespace = "flux-system"
  }

  data = {
    cluster_name       = var.cluster_name
    oidc_provider_arn  = module.eks.oidc_provider_arn
    aws_account_id     = data.aws_caller_identity.this.account_id
    region             = var.region
    environment        = var.env
    vpc_id             = var.vpc_id
    vpc_cidr_block     = var.vpc_cidr_block
    private_subnet_ids = jsonencode(var.private_subnets_ids)
  }
  depends_on = [kubernetes_namespace.flux_system]
}

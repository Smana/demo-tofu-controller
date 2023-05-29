data "aws_caller_identity" "this" {}

data "aws_availability_zones" "available" {}

# Flux
data "flux_install" "main" {
  target_path = "clusters/${var.cluster_name}"
}

data "flux_sync" "main" {
  target_path = "clusters/${var.cluster_name}"
  url         = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
  branch      = var.branch
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

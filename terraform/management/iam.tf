# Give admin permissions to the Terraform controller
module "iam_assumable_role_tfcontroller" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.9.2"
  create_role                   = true
  role_name                     = "tfcontroller_${var.cluster_name}"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:flux-system:tf-runner"]
}

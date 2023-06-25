# Give admin permissions to the Terraform controller
module "iam_assumable_role_tfcontroller" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "5.21.0"
  role_name = "tfcontroller_${var.cluster_name}"

  role_policy_arns = {
    policy = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["flux-system:tf-runner"]
    }
  }
}

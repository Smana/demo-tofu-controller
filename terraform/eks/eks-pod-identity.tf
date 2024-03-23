# Give admin permissions to the Terraform controller
# !! With with caution. For production use cases, prefer limit to the bare minimal

module "iam_role_tf_controller" {
  source                          = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version                         = "5.33.0"
  create_role                     = true
  create_custom_role_trust_policy = true
  custom_role_trust_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "pods.eks.amazonaws.com"
        },
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
    }
  )
  role_name        = "tf-controller"
  role_description = "EKS Pod Identity Role for the tofu-controller"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.iam_role_tf_controller.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_eks_pod_identity_association" "tf_controller" {
  cluster_name    = module.eks.cluster_name
  namespace       = "flux-system"
  service_account = "tf-runner"
  role_arn        = module.iam_role_tf_controller.iam_role_arn
}

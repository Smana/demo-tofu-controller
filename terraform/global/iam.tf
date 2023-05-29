module "iam_assumable_role_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "v5.9.2"

  allow_self_assume_role = true

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
    "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/smana" # User created using the console
  ]

  create_role             = true
  create_instance_profile = true

  role_name         = "admin"
  role_requires_mfa = false # Should be set to true in prod environments

  attach_admin_policy = true

  tags = {
    Role = "Admin"
  }
}

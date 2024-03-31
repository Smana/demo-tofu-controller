locals {
  env                 = "admin"
  region              = "eu-west-3"
  account_name        = "ogenki"
  account_id          = "396740644681" # This is my account ID! ;)
  public_domain_name  = "cloud.ogenki.io"
  private_domain_name = "priv.cloud.ogenki.io"
  tags = {
    env     = local.env
    project = "demo-tofu-controller"
    owner   = "Smana"
  }
}

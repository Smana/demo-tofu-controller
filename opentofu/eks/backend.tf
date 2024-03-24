terraform {
  backend "s3" {
    bucket  = "demo-smana-remote-backend"
    key     = "tofu-controller/eks/terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}

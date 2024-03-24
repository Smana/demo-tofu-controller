terraform {
  backend "s3" {
    bucket  = "demo-smana-remote-backend"
    key     = "tf-controller/network/terraform.tfstate"
    region  = "eu-west-3"
    encrypt = true
  }
}

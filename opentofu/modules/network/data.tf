data "aws_availability_zones" "available" {}

data "aws_secretsmanager_secret_version" "tailscale_api_key" {
  secret_id = var.tailscale_api_key_secretsmanager_name
}

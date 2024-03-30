locals {
  azs               = slice(data.aws_availability_zones.available.names, 0, 3)
  tailscale_api_key = jsondecode(data.aws_secretsmanager_secret_version.tailscale_api_key.secret_string)["api-key"]
}

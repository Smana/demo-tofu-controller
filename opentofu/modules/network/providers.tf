provider "tailscale" {
  api_key = jsondecode(data.aws_secretsmanager_secret_version.tailscale_api_key.secret_string)["api-key"]
  tailnet = jsondecode(data.aws_secretsmanager_secret_version.tailscale_api_key.secret_string)["tailnet"]
}

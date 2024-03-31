variable "env" {
  description = "The environment of the VPC"
  type        = string
}

variable "region" {
  description = "AWS Region"
  default     = "eu-west-3"
  type        = string
}

# Network
variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "private_domain_name" {
  description = "Route53 domain name for private records"
  type        = string
}

variable "tailscale_tailnet_name" {
  description = "Tailnet Name. ref: https://tailscale.com/kb/1136/tailnet"
  type        = string
}

variable "tailscale_subnet_router_name" {
  description = "Tailscale subnet router name"
  type        = string
}

variable "tailscale_api_key_secretsmanager_name" {
  type        = string
  description = "SecretsManager name from where to retrieve Tailscale API key"
  default     = "tailscale/api-key"
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

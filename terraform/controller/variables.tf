variable "env" {
  description = "The environment of the EKS cluster"
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

# EKS
variable "cluster_name" {
  description = "Name of the EKS cluster to be created"
  type        = string
}

variable "cluster_version" {
  description = "k8s cluster version"
  default     = "1.25"
  type        = string
}

# Flux
variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "github_token" {
  type        = string
  description = "github token"
  sensitive   = true
}

variable "repository_name" {
  type        = string
  description = "github repository name"
}

variable "branch" {
  type        = string
  default     = "main"
  description = "branch name"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

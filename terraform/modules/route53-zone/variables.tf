variable "domain_name" {
  description = "Name of the route53 hosted zone"
  type        = string
}

variable "comment" {
  description = "Comment that describe the hosted zone purpose"
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Whether to destroy all records in the zone when destroying the zone"
  type        = bool
  default     = false
}

variable "delegation_set_id" {
  description = "ID of the reusable delegation set whose NS records you want to assign to the hosted zone"
  type        = string
  default     = ""
}

variable "vpc" {
  description = "Configuration block(s) specifying VPC(s) to associate with a private hosted zone"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A mapping of tags"
  type        = map(string)
  default     = {}
}

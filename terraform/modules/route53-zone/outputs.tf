output "domain_name" {
  description = "Name of the hosted zone"
  value       = aws_route53_zone.this.name
}

output "zone_arn" {
  description = "The Amazon Resource Name (ARN) of the Hosted Zone."
  value       = aws_route53_zone.this.arn
}

output "zone_id" {
  description = "The Hosted Zone ID. This can be referenced by zone records"
  value       = aws_route53_zone.this.zone_id
}

output "nameservers" {
  description = "A list of name servers in associated (or default) delegation set"
  value       = aws_route53_zone.this.name_servers
}

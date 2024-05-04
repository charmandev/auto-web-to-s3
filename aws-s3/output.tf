output "site_url" {
  description = "The website endpoint of the S3 bucket"
  value = aws_s3_bucket.bucket_web.website_endpoint
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.certificate.arn
}

output "route53_record" {
  description = "The DNS record for the domain"
  value       = aws_route53_record.www.name
}
output "name_servers" {
  description = "The name servers for the Route53 zone"
  value       = aws_route53_zone.my_zone.name_servers
}

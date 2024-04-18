resource "aws_route53_zone" "my_zone" {
  name = "tuwebi.com.ar"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_route53_record" "www" {
  name    = "www.tuwebi.com.ar"
  type    = "A"
  zone_id = aws_route53_zone.my_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_dns" {
  for_each = { for idx, robo in flatten([for cert in aws_acm_certificate.certificate : cert.domain_validation_options]) : idx => {
    name   = robo.resource_record_name
    record = robo.resource_record_value
    type   = robo.resource_record_type
  } }

  zone_id = data.aws_route53_zone.certificate_route53_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns : record.fqdn]
}

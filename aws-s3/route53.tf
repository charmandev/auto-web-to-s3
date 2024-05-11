resource "aws_route53_zone" "my_zone" {
  name = "$DOMINIO"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_route53_record" "root" {
  name    = "$DOMINIO"
  type    = "A"
  zone_id = aws_route53_zone.my_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  name    = "www.$DOMINIO"
  type    = "A"
  zone_id = aws_route53_zone.my_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "cert_dns" {
  for_each = {
    for robo in aws_acm_certificate.certificate.domain_validation_options : robo.domain_name => {
      name   = robo.resource_record_name
      record = robo.resource_record_value
      type   = robo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.my_zone.zone_id
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns : record.fqdn]

  timeouts {
    create = "90m"  # tiempo máximo de espera para la creación del recurso
  } 
}

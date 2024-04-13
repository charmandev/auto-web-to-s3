terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "3.4"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

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
resource "aws_s3_bucket" "bucket_web" {
  bucket = var.bucket_name

  tags = {
    Name = format("%s-web", var.bucket_name)
  }

  website {
    index_document = "index.html"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "tuwebi.com.ar"
  validation_method = "EMAIL"

  tags = {
    Name = "tuwebi.com.ar"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  type    = each.value.type
  zone_id = aws_route53_zone.my_zone.zone_id
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

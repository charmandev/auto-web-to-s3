# ********************************* #
# * ACM *                           #
# ********************************* # 

provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "my_zone" {
  name = "tuwebi.com.ar"

  lifecycle {
    ignore_changes = all
  }
}

variable "root_domain_name" {
  type    = string
  default = "tuwebi.com.ar"
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.root_domain_name
  subject_alternative_names = ["*.${var.root_domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
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
} 
# ********************************* #
# * ACM *                           #
# ********************************* # 

provider "aws" {
  region = "us-east-1"
}


variable "root_domain_name" {
  type    = string
  default = "tuwebi.com.ar"
}

data "aws_route53_zone" "certificate_route53_zone" {
  name         = var.root_domain_name
  private_zone = false
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = var.root_domain_name
  subject_alternative_names = ["*.${var.root_domain_name}"]
  validation_method         = "EMAIL"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_dns" {
  count           = length(aws_acm_certificate.certificate.domain_validation_options)
  zone_id         = data.aws_route53_zone.certificate_route53_zone.zone_id
  name            = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_name
  type            = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_type
  records         = [aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_value]
  ttl             = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns : record.fqdn]
}
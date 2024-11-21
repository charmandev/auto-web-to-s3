# ********************************* #
# * ACM *                           #
# ********************************* #

data "aws_route53_zone" "certificate_route53_zone" {
  name         = aws_route53_zone.my_zone.name
  private_zone = false
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = aws_route53_zone.my_zone.name
  subject_alternative_names = [
    "www.${aws_route53_zone.my_zone.name}",     # www.example.com
    "www.dev-${aws_route53_zone.my_zone.name}" # www.dev-example.com
  ]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

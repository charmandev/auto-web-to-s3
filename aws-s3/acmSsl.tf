# ********************************* #
# * ACM *                           #
# ********************************* # 

data "aws_route53_zone" "certificate_route53_zone" {
  name         = aws_route53_zone.my_zone.name
  private_zone = false
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = aws_route53_zone.my_zone.name
  subject_alternative_names = ["*.${aws_route53_zone.my_zone.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# ********************************* #
# * ACM *                           #
# ********************************* # 

data "aws_route53_zone" "certificate_route53_zone" {
  name         = aws_route53_zone.my_zone.name
  private_zone = false
}

data "aws_acm_certificate" "existing_certificate" {
  domain   = aws_route53_zone.my_zone.name
  statuses = ["ISSUED"]  # Solo selecciona certificados válidos
}

output "certificate_arn" {
  value = data.aws_acm_certificate.existing_certificate.arn
}


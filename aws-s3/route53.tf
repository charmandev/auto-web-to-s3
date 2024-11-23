# Obtener la hosted zone existente
data "aws_route53_zone" "my_zone" {
  name         = var.DOMINIO
  private_zone = false  # Cambiar a true si la zona es privada
}

# Crear el registro raíz
resource "aws_route53_record" "root" {
  name    = "www.platform.${var.DOMINIO}"
  type    = "A"
  zone_id = data.aws_route53_zone.my_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Crear el registro www
resource "aws_route53_record" "www" {
  name    = "platform.${var.DOMINIO}"
  type    = "A"
  zone_id = data.aws_route53_zone.my_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Crear el registro dev
resource "aws_route53_record" "dev" {
  name    = "platform-dev.${var.DOMINIO}"
  type    = "A"
  zone_id = data.aws_route53_zone.my_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_dev.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_dev.hosted_zone_id
    evaluate_target_health = false
  }
}

# Crear los registros para la validación del certificado (si es necesario)
resource "aws_route53_record" "cert_dns" {
  for_each = {
    for dvo in aws_acm_certificate.existing_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.my_zone.zone_id
}

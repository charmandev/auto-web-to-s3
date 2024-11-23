# Obtener la hosted zone existente
data "aws_route53_zone" "my_zone" {
  name         = var.DOMINIO
  private_zone = false  # Cambiar a true si la zona es privada
}


# Crear el registro  $SUBDOMINIO
resource "aws_route53_record" "$SUBDOMINIO" {
  name    = " $SUBDOMINIO.${var.DOMINIO}"
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
  name    = " $SUBDOMINIO-dev.${var.DOMINIO}"
  type    = "A"
  zone_id = data.aws_route53_zone.my_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_dev.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_dev.hosted_zone_id
    evaluate_target_health = false
  }
}

# ********************************* #
# * ACM *                           #
# ********************************* # 

# Usar la hosted zone existente
data "aws_route53_zone" "certificate_route53_zone" {
  name         = var.DOMINIO
  private_zone = false
}

# Buscar un certificado existente
data "aws_acm_certificate" "existing_certificate" {
  domain   = var.DOMINIO
  statuses = ["ISSUED"]  # Solo selecciona certificados válidos
}

# Exportar el ARN del certificado existente
output "certificate_arn" {
  value = data.aws_acm_certificate.existing_certificate.arn
}


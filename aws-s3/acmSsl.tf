# ********************************* #
# * ACM *                           #
# ********************************* # 


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
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


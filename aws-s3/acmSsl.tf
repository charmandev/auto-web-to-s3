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
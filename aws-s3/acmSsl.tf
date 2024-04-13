resource "null_resource" "cert_validation" {
  triggers = {
    certificate_arn = aws_acm_certificate.cert.arn
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }
}
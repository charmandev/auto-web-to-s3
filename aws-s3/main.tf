terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "3.4"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

resource "aws_route53_zone" "my_zone" {
  name = "charmandev.com.ar"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_route53_record" "www" {
  name    = "www.charmandev.com.ar"
  type    = "A"
  zone_id = aws_route53_zone.my_zone.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
resource "aws_s3_bucket" "bucket_web" {
  bucket = var.bucket_name

  tags = {
    Name = format("%s-web", var.bucket_name)
  }

  website {
    index_document = "index.html"
  }
}



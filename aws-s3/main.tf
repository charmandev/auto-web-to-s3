terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "3.4"
    }
  }
  backend "s3" {
    bucket         = "tfstate-tar-testing-char"
    dynamodb_table = "my-terraform-state-lock-auto-web-to-s3-test4"
    key            = "environments/testing/aws-s3-bucket.tfstate"
    region         = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket_web" {
  bucket = var.bucket_name

  tags = {
    Name = format("%s-web", var.bucket_name)
  }

  website {
    index_document = "index.html"
  }

  lifecycle_rule {
    id      = "delete-bucket"
    enabled = true

    expiration {
      days = 0
    }
  }
}



}



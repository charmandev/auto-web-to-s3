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
  region     = "us-east-1"
}



resource "aws_s3_bucket" "bucket_web" {
  bucket = var.bucket_name

  tags = {
    Name = format("%s-web", var.bucket_name)
  }

  website {
    index_document = "index.html"
  }

  lifecycle {
    prevent_destroy = false
  }


}

data "aws_s3_bucket_objects" "bucket_objects" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_object" "bucket_objects" {
  for_each = { for key in data.aws_s3_bucket_objects.bucket_objects.keys : key => key }

  bucket = var.bucket_name
  key    = each.key

  # Agrega dependencia para que los objetos se eliminen antes de recrear el bucket
  depends_on = [aws_s3_bucket.bucket_web]
}


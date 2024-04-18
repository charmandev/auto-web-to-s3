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


resource "aws_s3_bucket" "bucket_web" {
  bucket = var.bucket_name

  tags = {
    Name = format("%s-web", var.bucket_name)
  }

  website {
    index_document = "index.html"
  }
}




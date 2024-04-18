terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "3.4"
    }
  }

    backend "s3" {
    bucket = "my-terraform-state"
    key    = "./terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-${var.bucket_name}"
    encrypt = true
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




terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "3.4"
    }
  }
/*
    backend "s3" {
    bucket = "my-terraform-state-webi-v1"
    key    = "./terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state"
    encrypt = true
  }
  */
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key_var
  secret_key = var.secret_key_var
}
/*
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}
*/
resource "aws_s3_bucket" "bucket_web" {
  bucket = var.bucket_name

  tags = {
    Name = format("%s-web", var.bucket_name)
  }

  website {
    index_document = "index.html"
  }
}




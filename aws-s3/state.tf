provider "aws" {
  region = "us-east-1"  # Cambia esto a la región que desees utilizar
}

# Configura el backend de Terraform para almacenar el estado en un bucket de S3
terraform {
  backend "s3" {
    bucket         = "state-${var.bucket_name}"  # Cambia "nombre-del-bucket" por el nombre de tu bucket en S3
    key            = "terraform.tfstate"  # Nombre del archivo de estado de Terraform en el bucket
    region         = "us-east-1"          # Cambia esto a la región donde está tu bucket
    dynamodb_table = "terraform-state-${var.bucket_name}"    # Nombre de la tabla DynamoDB para el locking state
    encrypt        = true                 # Opcional: si deseas cifrar el estado en S3
  }
}
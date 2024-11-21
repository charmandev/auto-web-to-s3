variable "bucket_name" {
  default = "$REPO"
}

variable "bucket_name_dev" {
  default = "dev-$REPO"
}

variable "DOMINIO" {
  description = "El dominio base utilizado para las distribuciones CloudFront"
  type        = string
  default     = "$DOMINIO" # Cambia esto por el valor predeterminado que necesites
}

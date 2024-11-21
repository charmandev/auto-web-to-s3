variable "bucket_name" {
  default = "$REPO"
}

variable "bucket_name_dev" {
  default = "dev-$REPO"
}

variable "DOMINIO" {
  default = "$DOMINIO" # Cambia esto por el valor predeterminado que necesites
}

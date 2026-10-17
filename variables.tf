variable "namespace" {
  type        = string
  default     = "Liora"
  description = "L'espace de noms de projet à utiliser pour la dénomination unique des ressources"
}


variable "region" {
  description = "AWS région"
  default     = "eu-west-3"
  type        = string
}

variable "db_pass" {
  type = string
  description = "password for database"
  sensitive = true
  nullable = false
}

variable "db_user" {
    type = string
    description = "user name for database"
    sensitive = true
    nullable = false
}
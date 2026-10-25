variable "namespace" {
  type        = string
  default     = "Anthony-TF-Exam"
  description = "L'espace de noms de projet à utiliser pour la dénomination unique des ressources"
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

variable "db_name" {
  type = string
  default = "mydb"
}

variable "authorised_cidrs" {
    type = list(string)
}

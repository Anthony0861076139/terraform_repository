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


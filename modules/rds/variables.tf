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

variable "namespace" {
    type = any
}


variable "db_name" {
    type = any
}


variable "db_subnet_group_name" {
    type = any
}

variable "sg_db_id" {
  type = string
}
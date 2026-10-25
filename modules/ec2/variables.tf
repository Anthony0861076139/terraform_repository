variable "type_instance" {
    type = string
    default = "t3.micro"
}

variable "key_name" {
    type = string
}

variable "vpc" {
    type = any
}

variable "sg_pub_id" {
    type = any
}

variable "sg_priv_id" {
    type = any
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

variable "namespace" {
    type = any
}


variable "db_name" {
    type = any
}

variable "db_host" {
    type = any
}
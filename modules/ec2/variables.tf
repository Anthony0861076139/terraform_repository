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

variable "namespace" {
    type = any
}

variable "avail_zone_var" {
    type = string
}
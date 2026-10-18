provider "aws" {
  region = "eu-west-3"
  #access_key = "${AWS_ACCESS_KEY_ID}"
  #secret_key = "${AWS_SECRET_ACCESS_KEY}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

module "ec2" {
  source          = "./modules/ec2"
  namespace       = var.namespace
  vpc             = module.networking.vpc
  sg_pub_id       = module.networking.sg_pub_id
  sg_priv_id      = module.networking.sg_priv_id
  key_name        = "Liora"
  avail_zone_var  = module.networking.azs[0]
}


module "rds" {
  source  = "./modules/rds"
  namespace  = var.namespace
  db_user = var.db_user
  db_pass = var.db_pass
}

module "ebs" {
  source = "./modules/ebs"
  namespace  = var.namespace
  avail_zone_var = module.networking.azs[0]
}
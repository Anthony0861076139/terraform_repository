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
  authorised_cidrs = var.authorised_cidrs
}

module "ec2" {
  source          = "./modules/ec2"
  namespace       = var.namespace
  vpc             = module.networking.vpc
  sg_pub_id       = module.networking.sg_pub_id
  sg_priv_id      = module.networking.sg_priv_id
  key_name        = "Anthony_Liora"
  db_user = var.db_user
  db_pass = var.db_pass
  db_name = var.db_name
  db_host = module.rds.db_host
}

module "ebs" {
  source = "./modules/ebs"
  namespace  = var.namespace
  avail_zone_var = module.ec2.ec2_avail_zone
  instance_id_var = module.ec2.instance_id
}



module "rds" {
  source  = "./modules/rds"
  namespace  = var.namespace
  db_user = var.db_user
  db_pass = var.db_pass
  db_name = var.db_name
  db_subnet_group_name = module.networking.db_subnet_group_name
}


output "wordpress_url" {
  value = "http://${module.ec2.public_ip_var}"
}
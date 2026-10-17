provider "aws" {
  region     = "eu-west-3"
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
  source    = "./liora-modules/modules/networking"
  namespace = var.namespace
}

module "ec2" {
  source     = "./liora-modules/modules/ec2"
  namespace  = var.namespace
  vpc        = module.networking.vpc
  sg_pub_id  = module.networking.sg_pub_id
  sg_priv_id = module.networking.sg_priv_id
  key_name   = "Liora"
}


data "aws_availability_zones" "available" {} #Dynamically get available zones

module "vpc" {                                      #Module vpc we will import from the registry thanks to terraform init
  source          = "terraform-aws-modules/vpc/aws" #Path inside https://registry.terraform.io
  version         = "~> 5.0"
  name            = "${var.namespace}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  #assign_generated_ipv6_cidr_block = true
  create_database_subnet_group = true
  enable_nat_gateway           = true #Allows outbound traffic for updating packages etc
  single_nat_gateway           = true #Allows outbound traffic only
}


resource "aws_security_group" "allow_ssh_pub" {
  name        = "${var.namespace}-allow_ssh_pub"
  description = "Authorise incoming ssh & HTTP INTERNET traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "allow incoming ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }


  ingress {
    description = "allow incoming http traffic"
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow incoming https traffic"
    from_port  = 443
    to_port    = 443
    protocol   = "tls"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    description = "allow outgoing traffic to the internet"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-allow_ssh_pub"
  }
}



resource "aws_security_group" "allow_ssh_priv" {
  name        = "${var.namespace}-allow_ssh_priv"
  description = "Authorise internal ssh & HTTP traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH uniqely for internal clients of the vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }


  ingress {
    description = "HTTP uniqely for internal clients of the vpc"
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow outgoing traffic to the internet"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-allow_ssh_priv"
  }


}
data "aws_availability_zones" "available" {} #Dynamically get available zones

module "vpc" {                                      #Module vpc we will import from the registry thanks to terraform init
  source                        = "terraform-aws-modules/vpc/aws" #Path inside https://registry.terraform.io
  version                       = "~> 5.0"
  name                          = "${var.namespace}-vpc"
  cidr                          = "10.0.0.0/16"
  azs                           = data.aws_availability_zones.available.names
  private_subnets               = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets                = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets              = ["10.0.201.0/24", "10.0.202.0/24"]
  create_database_subnet_group  = true
  enable_nat_gateway            = true                                  #Allows outbound traffic for updating packages etc
  single_nat_gateway            = true                                  #Allows outbound traffic only
}








resource "aws_security_group" "web_security_group" {
  name        = "${var.namespace}-web_security_group"
  description = "Authorise incoming ssh & HTTP INTERNET traffic"
  vpc_id      = module.vpc.vpc_id

  #ADMIN ACCESS - SSH ACCESS FOR AUTHORISED USERS ONLY WANTING TO CONNECT TO THE WEB SERVER'S LINUX SHELL   (nested block of web_security_group)
  ingress {
    description = "SSH for authorised personel for management purposes"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks  = var.authorised_cidrs #personal vm ip address (others may be added manually)
  }
  

  #USER ACCESS - HTTP WEB ACCESS FOR ALL WEB USERS WANTING TO CONNECT TO WORDPRESS (nested block of web_security_group)
  ingress {
    description = "allow incoming HTTP traffic from visitors to wordpress"
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #0.0.0.0/0 allows all incoming ip addresses
  }


  #USER ACCESS - HTTPS WEB ACCESS FOR ALL WEB USERS WANTING TO CONNECT TO WORDPRESS (nested block of web_security_group)
  ingress {
    description = "allow incoming HTTPS traffic from visitors to wordpress"
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #0.0.0.0/0 allows all incoming ip addresses
  }

#EC2 WEB SERVER WEB ACCESS FOR UPDATES ETC...  #nested block of web_security_group
  egress {
    description = "allow outgoing traffic to the internet"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-web_security_group"
  }
}









#the following is a block with nested blocks inside for ingress and egress rules
#This is the security guard that allows only certain people to enter the database
#This access is limited to ssh users

resource "aws_security_group" "db_security_group" {
  name        = "${var.namespace}-db_security_group"
  description = "Authorise internal ssh & HTTP traffic"
  vpc_id      = module.vpc.vpc_id

  

  #EC2 ACCESS - THIS GIVES THE WORDPRESS MACHINE ACCESS AND THEREFORE GIVES USERS AND ADMIN ACCESS TO THE DATABASE (nested block of db_security_group)
  ingress {
    description = "MySQL/MariaDB from the web server only"
    from_port  = 3306
    to_port    = 3306
    protocol   = "tcp"
    security_groups = [aws_security_group.web_security_group.id]
  }

  #RDS DATABASE WEB ACCESS FOR UPDATES ETC...  #nested block of web_security_group
  egress {
    description = "allow outgoing traffic to the internet"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = var.authorised_cidrs #personal vm ip address (others may be added manually)
  }

  tags = {
    Name = "${var.namespace}-db_security_group"
  }


}
data "aws_ami" "liora-ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}


resource "aws_instance" "ec2_public" {
    ami = data.aws_ami.liora-ami.id
    instance_type = var.type_instance
    key_name = var.key_name
    associate_public_ip_address = true
    subnet_id = var.vpc.public_subnets[0]
    vpc_security_group_ids = [var.sg_pub_id]
    user_data = file("install_wordpress.sh")
    availability_zone = var.avail_zone_var

     tags = {
    "Name" = "${var.namespace}-EC2-PUBLIC"
  }
}

#No private ec2 instance needed in this exam. the database will be created in rds and a private subnet will be assigned to it
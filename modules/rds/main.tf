resource "aws_db_instance" "liora-db" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mariadb"
  engine_version       = "10.11"
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = var.db_pass
  parameter_group_name = "default.mariadb10.11"
  skip_final_snapshot  = true
  multi_az             = true
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = [var.sg_db_id]
  apply_immediately      = true

  tags = {
    Name = "${var.namespace}-rds"
  }
}


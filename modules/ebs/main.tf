resource "aws_ebs_volume" "liora-ebs" {
  size = 10
  availability_zone = var.avail_zone_var
  tags = {
    Name = "${var.namespace}-ebs"
  }
}


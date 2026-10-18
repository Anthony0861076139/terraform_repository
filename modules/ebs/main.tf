resource "aws_ebs_volume" "liora-ebs" {
  size = 10
  availability_zone = var.avail_zone_var
  tags = {
    Name = "${var.namespace}-ebs"
  }
}

resource "aws_volume_attachment" "liora_ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.liora-ebs.id
  instance_id = var.instance_id_var
}
output "instance_id" {
    value = aws_instance.ec2_public.id
}


output "public_ip_var" {
    value = aws_instance.ec2_public.public_ip
}

output "ec2_avail_zone" {
    value = aws_instance.ec2_public.availability_zone
}
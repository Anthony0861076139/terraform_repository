output "vpc" {
    value = module.vpc
}

output "sg_pub_id" {
    value = aws_security_group.web_security_group.id
}

output "sg_db_id" {
    value = aws_security_group.db_security_group.id
}

output "azs" {
    value = module.vpc.azs
}

output "db_subnet_group_name" {
    value = module.vpc.database_subnet_group_name
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "instance_sg" {
  value = aws_security_group.instance_sg.id
}


# output "rds_sg_id" {
#   value = aws_security_group.rds_sg.id
# }
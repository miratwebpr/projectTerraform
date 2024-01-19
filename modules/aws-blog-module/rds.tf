# # NOTE! There are some parts that you need to change and uncomment. Pay attention to comments.

# resource "aws_rds_cluster" "project" {
#   cluster_identifier        = "project"
#   availability_zones        = var.availability_zones
#   engine                    = "mysql"
#   db_cluster_instance_class = "db.m5d.large"
#   storage_type              = "io1"
#   allocated_storage         = 100
#   iops                      = 1000
#   master_username           = var.db_info[1]
#   master_password           = var.db_info[2]
#   database_name             = var.db_info[0]
#   db_subnet_group_name      = aws_db_subnet_group.private_subnet.name
#   skip_final_snapshot       = true
#   vpc_security_group_ids = [aws_security_group.projectSG_RDS.id]
#   # Uncomment it when deploying on the final stage. It will automatically assign security group to this cluster.
# }

resource "aws_db_subnet_group" "private_subnet" {
  name       = "private_subnet_group"
  subnet_ids = aws_subnet.private_subnet[*].id
  tags = {
    name = "private subnet group"
  }
}

resource "aws_db_instance" "project" {
  allocated_storage      = 20
  storage_type           = "gp3"
  db_name                = var.db_info[0]
  engine                 = "mysql"
  instance_class         = "db.t2.micro"
  username               = var.db_info[1]
  password               = var.db_info[2]
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.private_subnet.name
  vpc_security_group_ids = [aws_security_group.projectSG_RDS.id]
}

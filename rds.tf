resource "aws_db_subnet_group" "db-subnet" {
  name       = "mysql-subnet-group"
  subnet_ids = aws_subnet.private_subnet[*].id
}

resource "aws_rds_cluster" "project_rds_cluster" {
  cluster_identifier        = "project-rds-cluster"
  availability_zones        = var.availability_zones
  engine                    = "mysql"  # Specify MySQL as the engine
  engine_version            = "8.0.35" # Choose the desired MySQL version
  db_cluster_instance_class = "db.m5d.large"
  storage_type              = "io1"
  allocated_storage         = 100
  iops                      = 1000
  master_username           = "admin"
  master_password           = "admin123"
  database_name             = "projectdb"
  skip_final_snapshot       = true
  backup_retention_period   = 7
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.db-subnet.name
  port                      = 3306
}

output "rds_cluster_endpoint" {
  value = aws_rds_cluster.project_rds_cluster.endpoint
}


resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.instance_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_security_group"
  }
}

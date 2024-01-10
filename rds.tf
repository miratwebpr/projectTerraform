# NOTE! There are some parts that you need to change and uncomment. Pay attention to comments.

resource "aws_rds_cluster" "project" {
  cluster_identifier        = "project"
  availability_zones        = var.availability_zones
  engine                    = "mysql"
  db_cluster_instance_class = "db.m5d.large"
  storage_type              = "io1"
  allocated_storage         = 100
  iops                      = 1000
  master_username           = "test"
  master_password           = "Techtorial123"
  database_name             = "project"
  db_subnet_group_name      = aws_db_subnet_group.private_subnet.name
  skip_final_snapshot       = true
  enable_http_endpoint      = true
  # vpc_security_group_ids = aws_security_group.projectSG_RDS.id  
  # Uncomment it when deploying on the final stage. It will automatically assign security group to this cluster.
}

resource "aws_db_subnet_group" "private_subnet" {
  name        = "private_subnet_group"
  subnet_ids  = aws_subnet.private_subnet[*].id
  tags = {
    name = "private subnet group"
  }
}
# resource "aws_route53_zone" "main" {
#   name = "salokhiddin.link"   # Replace it with your domain name
# }

# resource "aws_route53_record" "hosted" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = "writer"
#   type    = "CNAME"
#   ttl     = 90
#   records = ["salokhiddin.link"]  # Replace with your domain name
# }
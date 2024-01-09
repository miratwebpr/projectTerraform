# # Specify the region in which we would want to deploy our stack
# variable "region" {
#   default = "us-east-1"
# }

# # Specify 3 availability zones from the region
# variable "availability_zones" {
#   default = ["us-east-1a", "us-east-1b", "us-east-1c"]
# }

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# # Configure the AWS Provider
# provider "aws" {
#   region = var.region
# }

# # Create a VPC
# resource "aws_vpc" "my_vpc" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "my_vpc"
#   }
# }

# # Create a public and private subnet in each availability zone in the VPC
# resource "aws_subnet" "public_subnet" {
#   count                   = length(var.availability_zones)
#   cidr_block              = element(["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], count.index)
#   availability_zone       = element(var.availability_zones, count.index)
#   map_public_ip_on_launch = true
#   vpc_id                  = aws_vpc.my_vpc.id
# }

# resource "aws_subnet" "private_subnet" {
#   count                   = length(var.availability_zones)
#   cidr_block              = element(["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"], count.index)
#   availability_zone       = element(var.availability_zones, count.index)
#   map_public_ip_on_launch = false
#   vpc_id                  = aws_vpc.my_vpc.id
# }

# # Create a MySQL RDS instance in the private subnet
# resource "aws_db_instance" "mysql_instance" {
#   identifier             = "mysql-demo-instance"
#   engine                 = "mysql"
#   engine_version         = "8.0"  # Choose a valid MySQL version
#   instance_class         = "db.t2.micro"
#   allocated_storage      = 10
#   storage_type           = "gp2"
#   username               = "foo"
#   password               = "Saloh5560"
#   db_subnet_group_name   = aws_db_subnet_group.private.name
#   # vpc_security_group_ids = [aws_security_group.mysql_sg.id]  # Replace with the ID of your security group
#   skip_final_snapshot       = false
#   final_snapshot_identifier = "foo"
# }

# resource "aws_db_subnet_group" "private" {
#   name       = "private-subnet-group"
#   subnet_ids = aws_subnet.private_subnet[*].id
# }

# resource "aws_security_group" "mysql_sg" {
#   # Define your security group settings here
# }

# # Output the IDs of public and private subnets
# output "public_subnet_ids" {
#   value = aws_subnet.public_subnet[*].id
# }

# output "private_subnet_ids" {
#   value = aws_subnet.private_subnet[*].id
# }
# resource "aws_dynamodb_table" "basic-dynamodb-table" {
#   name           = "GameScores"
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 20
#   write_capacity = 20
#   hash_key       = "UserId"
#   range_key      = "GameTitle"
  
  
  

#   attribute {
#     name = "UserId"
#     type = "S"
#   }

#   attribute {
#     name = "GameTitle"
#     type = "S"
#   }

#   attribute {
#     name = "TopScore"
#     type = "N"
#   }

#   ttl {
#     attribute_name = "TimeToExist"
#     enabled        = false
#   }

#   global_secondary_index {
#     name               = "GameTitleIndex"
#     hash_key           = "GameTitle"
#     range_key          = "TopScore"
#     write_capacity     = 10
#     read_capacity      = 10
#     projection_type    = "INCLUDE"
#     non_key_attributes = ["UserId"]
#   }

#   tags = {
#     Name        = "dynamodb-table-1"
#   }
# }

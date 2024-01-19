variable "region" {
  description = "Aws region for our project"
  type        = string
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for our instances and VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "db_info" {
  description = "AWS RDS(database) information for 0 - db_name, 1 - db_username, 2 - db_password"
  type        = list(string)
  default     = []
}

variable "s3_bucket_name" {
  description = "A bucket name for our s3"
  type        = string
}

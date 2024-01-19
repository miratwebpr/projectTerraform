output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.project_vpc.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.datatechtorialbucket.arn
}

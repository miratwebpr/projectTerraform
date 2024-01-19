output "vpc_public_subnets" {
  value = module.aws-blog-module.public_subnet_ids
}
output "vpc_private_subnets" {
  value = module.aws-blog-module.private_subnet_ids
}
output "vpcid" {
  value = module.aws-blog-module.vpc_id
}
output "s3arn" {
  value = module.aws-blog-module.s3_bucket_arn
}


module "aws-blog-module" {
	source = "./modules/aws-blog-module"
	region = "us-east-2"

	availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

	db_info = ["group2_db", "group2", "techtorial123"]

	s3_bucket_name = "datatechtorialbucket"
}

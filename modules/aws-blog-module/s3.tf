# terraform {
#   backend "s3" {
#     bucket                  = "stateprojectgroup2"
#     key                     = "terraform.tfstate"   
#     region                  = "us-east-1"
#   }
# }

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.datatechtorialbucket.id
  policy = <<EOF
            {
                "Id": "Policy1704934700978",
                "Version": "2012-10-17",
                "Statement": [
                    {
                    "Sid": "Stmt1704934699558",
                    "Action": "s3:*",
                    "Effect": "Allow",
                    "Resource": "${aws_s3_bucket.datatechtorialbucket.arn}/*",
                    "Principal": "*"
                    }
                ]
            }
    EOF
}

resource "aws_s3_bucket" "datatechtorialbucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "datatechtorialbucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.datatechtorialbucket_OC,
    aws_s3_bucket_public_access_block.datatechtorialbucket_PAB,
  ]

  bucket = aws_s3_bucket.datatechtorialbucket.id
  acl    = "public-read-write"
}
resource "aws_s3_bucket_ownership_controls" "datatechtorialbucket_OC" {
  bucket = aws_s3_bucket.datatechtorialbucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "datatechtorialbucket_PAB" {
  bucket = aws_s3_bucket.datatechtorialbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_iam_role" "s3accessforec2_role" {
  name = "s3accessforec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3accessforec2_policy" {
  name        = "bucketaccessforec2"
  description = "Grants an access for s3 buckets from instances"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListBucket", "s3:PutBucketPolicy"]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.datatechtorialbucket.arn]
      },
      {
        Action   = ["s3:GetObject", "s3:PutObject"]
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.datatechtorialbucket.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3accessforec2_policy_attachment" {
  role       = aws_iam_role.s3accessforec2_role.name
  policy_arn = aws_iam_policy.s3accessforec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.s3accessforec2_role.name
}


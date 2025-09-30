############################################################################
#  Bucket S3
############################################################################
resource "aws_s3_bucket" "bucket" {
  provider = aws.local
  bucket   = var.bucket_name
  tags     = merge({
    "Name"		= var.bucket_name
    },
    var.default_tags,	
  ) 
}
resource "aws_s3_bucket_public_access_block" "bucket-acces-public" {
  provider                = aws.local
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
# resource "aws_s3_bucket_versioning" "s3-versioning" {
#   provider = aws.local
#   bucket   = aws_s3_bucket.bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption-buecket" {
  provider = aws.local
  bucket   = aws_s3_bucket.bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

############################################################################
#  Bucket S3 GENESYS GRABACIONES
############################################################################
resource "aws_s3_bucket" "bucket_genesys" {
  provider = aws.local
  bucket   = var.bucket_genesys
  tags     = merge({
    "Name"		= var.bucket_genesys},
    var.default_tags,	
  ) 
}
resource "aws_s3_bucket_public_access_block" "bucket-acces-public-genesys" {
  provider                = aws.local
  bucket                  = aws_s3_bucket.bucket_genesys.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption-buecket-genesys" {
  provider = aws.local
  bucket   = aws_s3_bucket.bucket_genesys.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
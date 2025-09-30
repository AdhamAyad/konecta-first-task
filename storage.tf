resource "aws_s3_bucket" "backup" {
  bucket = "s3-backup-nativo-kdma"
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "stackset-stacksetcloudtrailwitchcloud-trailbucket-c620srhti8hu"

  tags = {
    Platform = "Cloudformation"
  }
}
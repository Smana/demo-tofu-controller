resource "aws_s3_bucket" "this" {
  bucket        = "demo-smana-remote-backend"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = "demo-smana-remote-backend"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = "demo-smana-remote-backend"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

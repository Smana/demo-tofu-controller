resource "aws_s3_bucket" "terraform-state" {
  bucket        = "demo-smana-remote-backend"
  force_destroy = true
}


resource "aws_s3_bucket_versioning" "version" {
  bucket = "demo-smana-remote-backend"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "first" {
  bucket = "demo-smana-remote-backend"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

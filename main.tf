# craete S3 bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket
}


resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#make the bucket public, 
#disables the default S3 bucket security settings(AWS recommends using bucket policies rather than bucket ACLs for public read access.)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# website configuration resource
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"

}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "styles" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "styles.css"
  source = "styles.css"
  acl = "public-read"
  content_type = "text/css"

}

#S3 bucket website configuration resource
resource "aws_s3_bucket_website_configuration" "web_config" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.acl ]
  }
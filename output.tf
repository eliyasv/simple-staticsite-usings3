output "website_url" {
  value = "http://${aws_s3_bucket.mybucket.bucket_domain_name}"
}

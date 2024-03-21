output "site_url" {
  value = aws_s3_bucket.bucket_web.website_endpoint
}
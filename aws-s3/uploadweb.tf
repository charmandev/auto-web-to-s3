
resource "aws_s3_bucket_object" "site_files" {
  for_each = fileset("${path.module}/web", "**/*")

  bucket = aws_s3_bucket.bucket_web.id
  key    = replace(each.value, "^web/", "")
  source = "${path.module}/web/${each.value}"
  content_type = lookup({
    "tml" : "text/html",
    "css"  : "text/css",
    "jpg"  : "image/jpeg",
    "peg" : "image/jpeg",
    "png"  : "image/png",
    "gif"  : "image/gif",
    "svg"  : "image/svg+xml",
    ".js"   : "application/javascript",
  }, lower(substr(basename(each.value), -3, 3)), "application/octet-stream")
}


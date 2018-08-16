resource "aws_s3_bucket" "site" {
    bucket = "${var.bucket_site}"
    acl = "public-read"
    website {
        index_document = "index.html"
        error_document = "404.html"
    }
    tags {
      Project = "${var.name}"
    }
    cors_rule {
      allowed_headers = ["*"]
      allowed_methods = ["GET"]
      allowed_origins = ["${var.domain_name}"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
    force_destroy = true
    policy = <<EOF
{
        "Id": "bucket_policy_site",
        "Version": "2012-10-17",
        "Statement": [
          {
            "Sid": "bucket_policy_site_main",
            "Action": [
              "s3:GetObject"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::${var.bucket_site}/*",
            "Principal": "*"
          }
        ]
      }
EOF
}

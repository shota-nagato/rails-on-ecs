data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}

locals {
  cloudfront_cannonical_user_id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
}

resource "aws_s3_bucket" "logs" {
  bucket        = "${var.common.prefix}-${var.common.environment}-logs-bucket"
  force_destroy = true

  tags = {
    Name = "${var.common.prefix}-${var.common.environment}-logs-bucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ALBやCloudFrontがアップロードしたオブジェクトもバケット所有者に帰属させる
resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ACL設定
resource "aws_s3_bucket_acl" "logs" {
  depends_on = [aws_s3_bucket_ownership_controls.logs]
  bucket     = aws_s3_bucket.logs.id

  acl = "log-delivery-write"
}

data "aws_iam_policy_document" "logs" {
  statement {
    sid = "ALBLogPut"
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
  }

  statement {
    sid = "CloudFrontAccessLogs"
    principals {
      type        = "CanonicalUser"
      identifiers = [local.cloudfront_cannonical_user_id]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
  }

  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.logs.arn,
      "${aws_s3_bucket.logs.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.logs.json
}

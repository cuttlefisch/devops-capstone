resource "random_uuid" "random_id" {}

resource "aws_s3_bucket" "frontend" {
  #checkov:skip=CKV2_AWS_6:Website should be publicly accessible
  #checkov:skip=CKV_AWS_19:Don't encrypt publicly accessible website
  #checkov:skip=CKV_AWS_20:Website should be publicly accessible
  #checkov:skip=CKV_AWS_21:Versioning of websited is handled through git
  #checkov:skip=CKV_AWS_145:Don't encrypt publicly accessible website
}

resource "aws_s3_bucket_policy" "frontend" {
}

data "aws_iam_policy_document" "frontend" {
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  #checkov:skip=CKV_AWS_53:Website should be publicly accessible
  #checkov:skip=CKV_AWS_54:Website should be publicly accessible
  #checkov:skip=CKV_AWS_55:Website should be publicly accessible
  #checkov:skip=CKV_AWS_56:Website should be publicly accessible
}



resource "aws_s3_bucket" "logging" {
  #checkov:skip=CKV_AWS_18:This is the logging bucket
  bucket        = "access-logs-${random_uuid.random_id.id}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_logging" {
  bucket = aws_s3_bucket.logging.bucket
  policy = data.aws_iam_policy_document.bucket_logging.json
}

data "aws_elb_service_account" "main" {}


data "aws_iam_policy_document" "bucket_logging" {
  statement {
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/*/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }

  statement {
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/*/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.logging.bucket}"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}


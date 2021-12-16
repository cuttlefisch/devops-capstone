resource "aws_kms_key" "project" {
  description         = "${var.project_name}-key"
  policy              = data.aws_iam_policy_document.kms_key.json
  enable_key_rotation = true
}

data "aws_iam_policy_document" "kms_key" {
  statement {
    sid = "Enable IAM User Permissions"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*",
      ]
    }
  }

  statement {
    sid     = "Decrypte kms for lambda"
    actions = ["kms:Decrypt", ]

    resources = [
      "*",
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.project.arn]
    }
  }
}


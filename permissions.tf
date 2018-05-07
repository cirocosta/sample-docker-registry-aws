data "aws_iam_policy_document" "bucket-root" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket}",
    ]
  }
}

data "aws_iam_policy_document" "bucket-subdirs" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket}/*",
    ]
  }
}

data "aws_iam_policy_document" "default" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = "default"
  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_role_policy" "bucket-root" {
  name   = "bucket-root-s3"
  role   = "${aws_iam_role.main.name}"
  policy = "${data.aws_iam_policy_document.bucket-root.json}"
}

resource "aws_iam_role_policy" "bucket-subdirs" {
  name   = "bucket-subdirs-s3"
  role   = "${aws_iam_role.main.name}"
  policy = "${data.aws_iam_policy_document.bucket-subdirs.json}"
}

resource "aws_iam_instance_profile" "main" {
  name = "instance-profile"
  role = "${aws_iam_role.main.name}"
}

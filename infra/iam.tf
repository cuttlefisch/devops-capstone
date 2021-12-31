resource "aws_iam_instance_profile" "backend_server" {
  name = "backend-api-profile"
  role = aws_iam_role.project.name
}

resource "aws_iam_role" "project" {
  name               = "project-main-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.aws_tags
}

data "aws_iam_policy_document" "assume_role" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

}

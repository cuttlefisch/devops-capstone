resource "aws_security_group" "backend_server" {
  #checkov:skip=CKV_AWS_24:Enable ssh access from all sources since we don't have access to private GH Actions runners
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "backend_server" {
  #checkov:skip=CKV_AWS_88:Allow public IP for ssh access deploy since we don't have access to private GH Actions runners
  depends_on = [aws_route_table.main]

  tags = var.aws_tags
}


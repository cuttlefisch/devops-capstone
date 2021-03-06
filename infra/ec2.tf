resource "aws_security_group" "backend_server" {
  #checkov:skip=CKV_AWS_24:Enable ssh access from all sources since we don't have access to private GH Actions runners
  name        = "backend-server-sg"
  description = "Allow port inbound TLS traffic, and all egress."
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  count                       = length(data.aws_availability_zones.available.names)
  depends_on                  = [aws_route_table.main]
  tags                        = var.aws_tags
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.aws_ec2_instance_type
  subnet_id                   = aws_subnet.main[count.index].id
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.backend_server.id}"]
  key_name                    = aws_key_pair.ssh_key.key_name
}

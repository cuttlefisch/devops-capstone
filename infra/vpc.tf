data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_vpc_endpoint" "main" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.backend_server.id]
}

resource "aws_subnet" "main" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_subnet" "public" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.${count.index + length(data.aws_availability_zones.available.names)
  }.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "main_main" {
  count          = length(aws_subnet.main)
  subnet_id      = aws_subnet.main.*.id[count.index]
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "main_public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.main.id
}

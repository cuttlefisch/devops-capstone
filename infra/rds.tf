resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = aws_subnet.main.*.id
}

resource "random_password" "postgres_admin_password" {
  length  = 32
  special = false
}

resource "random_password" "postgres_app_password" {
  length  = 32
  special = false
}

# REVIEW may need to use count for specified azs
resource "aws_db_instance" "postgres" {
  #checkov:skip=CKV_AWS_17:Create public IP because we don't have access to private GH Actions runners
  # count                = length(data.aws_availability_zones.available)
  apply_immediately    = true
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  username             = "CHANGEME"
  password             = random_password.postgres_admin_password.result
  multi_az             = true
  publicly_accessible  = true
  allocated_storage    = 5
  db_subnet_group_name = aws_db_subnet_group.main.name
  # availability_zone    = data.aws_availability_zones.available[count.index]


  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      latest_restorable_time,
    ]
  }
}

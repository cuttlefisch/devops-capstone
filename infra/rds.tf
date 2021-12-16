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

resource "aws_db_instance" "postgres" {
  #checkov:skip=CKV_AWS_17:Create public IP because we don't have access to private GH Actions runners
  apply_immediately = true

  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      latest_restorable_time,
    ]
  }
}


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
  name                                = "todobackenddb"
  apply_immediately                   = true
  engine                              = "postgres"
  engine_version                      = "13.4"
  instance_class                      = "db.t3.micro"
  username                            = "CHANGEME"
  password                            = random_password.postgres_admin_password.result
  multi_az                            = true
  publicly_accessible                 = true
  allocated_storage                   = 5
  db_subnet_group_name                = aws_db_subnet_group.main.name
  iam_database_authentication_enabled = true
  backup_retention_period             = 0
  final_snapshot_identifier           = "backend-db-final-snapshot"
  vpc_security_group_ids              = [aws_security_group.postgres-sg.id]
  # availability_zone    = data.aws_availability_zones.available[count.index]

  lifecycle {
    ignore_changes = [
      snapshot_identifier,
      latest_restorable_time,
    ]
  }
}

resource "aws_security_group" "postgres-sg" {
  name        = "postgres-sg"
  description = "Allow postgres db traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # TODO switch to private subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "postgresql_role" "app_role" {
#   name        = "todo_app"
#   login       = true
#   password    = var.postgres_admin_pass # random_password.postgres_app_password.result
#   create_role = true
#   provider    = postgresql
# }

# # resource "postgresql_role" "application_role" {
# #   name               = "todo_app"
# #   login              = true
# #   password           = random_password.postgres_app_password.result
# #   encrypted_password = false
# #   depends_on         = [aws_db_instance.postgres]
# # }

# resource "postgresql_database" "dev_db" {
#   name              = "todo-database"
#   owner             = postgresql_role.app_role.name
#   allow_connections = true
#   provider          = postgresql
# }

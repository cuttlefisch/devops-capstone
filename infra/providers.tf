terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.14.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_caller_identity" "current" {}


provider "github" {
  token = var.github_token # or `${GITHUB_TOKEN}`
  owner = var.github_user
}

provider "postgresql" {
  host             = aws_db_instance.postgres.address
  username         = "CHANGEME"
  password         = var.postgres_admin_pass
  sslmode          = "require"
  superuser        = true
  expected_version = aws_db_instance.postgres.engine_version
}

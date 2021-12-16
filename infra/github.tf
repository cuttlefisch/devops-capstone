data "github_actions_public_key" "capstone" {
  repository = var.github_repo
}

data "github_ip_ranges" "hosted" {}

locals {
  github_env_secrets = [
    {
      name  = "POSTGRES_ADDRESS"
      value = aws_db_instance.postgres.endpoint
    },
    {
      name  = "POSTGRES_APP_USERNAME"
      value = "todo_app"
    },
    {
      name  = "POSTGRES_APP_PASSWORD"
      value = random_password.postgres_app_password.result
    },
    {
      name  = "POSTGRES_ADMIN_USERNAME"
      value = aws_db_instance.postgres.username
    },
    {
      name  = "POSTGRES_ADMIN_PASSWORD"
      value = aws_db_instance.postgres.password
    },
    {
      name  = "POSTGRES_DATABASE"
      value = aws_db_instance.postgres.name
    },
    {
      name  = "S3_BUCKET_NAME"
      value = aws_s3_bucket.frontend.bucket
    },
    {
      name  = "AWS_REGION"
      value = var.region
    },
    {
      name  = "SSH_PRIVATE_KEY"
      value = tls_private_key.ssh.private_key_pem
    },
    {
      name  = "EC2_INSTANCE_IPS"
      value = join(" ", aws_instance.backend_server.*.public_ip)
    },
    {
      name  = "EC2_INSTANCE_USER"
      value = var.aws_ec2_username
    },
    {
      name  = "SECURITY_GROUP_ID"
      value = aws_security_group.backend_server.id
    },
    {
      name  = "RDS_DB_IDENTIFIER"
      value = aws_db_instance.postgres.identifier
    },
    {
      name  = "BASE64_SSH_PRIVATE_KEY"
      value = base64encode(tls_private_key.ssh.private_key_pem)
    },
    {
      name  = "GATSBY_REMOTE_SCHEMA_URL"
      value = "https://${aws_lb.backend_server.dns_name}/query"
    },
  ]
}

resource "github_repository_environment" "capstone" {
  environment = var.environment
  repository  = var.github_repo
}

resource "github_actions_environment_secret" "capstone_secret" {
  count           = length(local.github_env_secrets)
  environment     = github_repository_environment.capstone.environment
  repository      = var.github_repo
  secret_name     = local.github_env_secrets[count.index].name
  plaintext_value = local.github_env_secrets[count.index].value
}

resource "github_actions_secret" "capstone_aws_access_key_id" {
  repository      = var.github_repo
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.access_key
}

resource "github_actions_secret" "capstone_aws_secret_access_key" {
  repository      = var.github_repo
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.secret_key
}

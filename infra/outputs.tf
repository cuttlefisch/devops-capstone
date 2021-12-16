output "todo_app_url" {
  value = "http://${aws_s3_bucket.frontend.website_endpoint}"
}

output "todo_backend_alb_url" {
  value = "https://${aws_lb.backend_server.dns_name}"
}

output "aws_ec2_instance_ips" {
  value = join(" ", aws_instance.backend_server.*.public_ip)
}

output "postgres_db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

resource "aws_lb" "backend_server" {
  #checkov:skip=CKV_AWS_150:Disable deletion protection since this is a learning project
  name                       = "${var.project_name}-backend-server"
  enable_deletion_protection = false
  internal                   = false
  load_balancer_type         = "application"
  drop_invalid_header_fields = true

  security_groups = [
    aws_security_group.backend_server.id
  ]

  subnets = aws_subnet.public.*.id

  access_logs {
    bucket  = aws_s3_bucket.logging.id
    prefix  = "${var.project_name}-lb-access"
    enabled = true
  }
}

resource "aws_lb_target_group" "backend_server_8080" {
  name                 = "${var.project_name}-8080"
  port                 = 8080
  protocol             = "HTTP"
  deregistration_delay = 10
  vpc_id               = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    path                = "/health-check"
  }
}

resource "aws_lb_target_group_attachment" "backend_server_8080" {
  count = length(aws_instance.backend_server)

  target_group_arn = aws_lb_target_group.backend_server_8080.arn
  target_id        = aws_instance.backend_server.*.id[count.index]
  port             = 8080
}

resource "aws_lb_listener" "backend_server_443" {
  load_balancer_arn = aws_lb.backend_server.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.example.arn

  default_action {
    target_group_arn = aws_lb_target_group.backend_server_8080.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "backend_server_redirect" {
  load_balancer_arn = aws_lb.backend_server.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb" "main_lb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.alb_security_groups.*.id
  subnets            = var.public_subnets.*.id

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "main_gr" {
  name        = var.alb_tg_name
  port        = var.alb_tg_port //needs to be the port of my app
  protocol    = var.alb_tg_protocol
  vpc_id      = var.vpc_id
  target_type = var.alb_tg_target_type

  health_check {
    protocol            = var.alb_tg_protocol
    matcher             = var.alb_tg_matcher
    path                = var.alb_tg_path
  }

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_lb.main_lb]
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main_lb.id
  port              = var.http_listener_port
  protocol          = var.http_listener_protocol

  default_action {
    type = var.http_listener_action_type

    redirect {
      port        = var.http_listener_redirect_port
      protocol    = var.http_listener_redirect_protocol
      status_code = var.http_listener_redirect_status_code
    }
  }
}

# Redirect traffic to target group
resource "aws_alb_listener" "https" {
    load_balancer_arn = aws_lb.main_lb.id
    port              = var.https_listener_port
    protocol          = var.https_listener_protocol

    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = var.alb_tls_cert_arn

    default_action {
        target_group_arn = aws_alb_target_group.main_gr.id
        type             = "forward"
    }
}
// load balancer

module "load_balancer" {
    source = "./modules/alb"
    // load balancer
    alb_name = "${var.name}-alb-${var.environment}"
    environment = var.environment
    internal = var.internal
    load_balancer_type = var.load_balancer_type
    alb_security_groups = [aws_security_group.alb-sg]
    public_subnets = [module.public_subnet_1.mySubnet, module.public_subnet_2.mySubnet]
    enable_deletion_protection = var.enable_deletion_protection
    // load balancer target group
    alb_tg_name = "${var.name}-tg-lb-${var.environment}"
    alb_tg_port = var.alb_tg_port
    alb_tg_protocol = var.alb_tg_protocol
    vpc_id = aws_vpc.main.id
    alb_tg_target_type = var.alb_tg_target_type
    alb_tg_matcher = var.alb_tg_matcher 
    alb_tg_path = var.alb_tg_path
    // http listener
    http_listener_port = var.http_listener_port
    http_listener_protocol = var.http_listener_protocol
    http_listener_action_type = var.http_listener_action_type
    http_listener_redirect_port = var.http_listener_redirect_port
    http_listener_redirect_protocol = var.http_listener_redirect_protocol
    http_listener_redirect_status_code = var.http_listener_redirect_status_code
    // https listener
    https_listener_port = var.https_listener_port
    https_listener_protocol = var.https_listener_protocol
    alb_tls_cert_arn = var.alb_tls_cert_arn 
}
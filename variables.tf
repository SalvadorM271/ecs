variable region {
    default = "us-east-2"
}
variable environment {}
variable name {}

//vpc
variable cidr {}

//subnets
variable subnet_cidr_block {}
variable availability_zone {}
variable map_public_ip_on_launch {}

//ecs
variable net_mode {}
variable ecs_type {}
variable container_cpu {}
variable container_memory {}
variable container_image {}
variable essential {}
variable container_port {}
variable container_host_port {}
variable protocol {}
variable log_driver {}
variable service_desired_count {}
variable deployment_minimum_healthy_percent {}
variable deployment_maximum_percent {}
variable health_check_grace_period_seconds {}
variable scheduling_strategy {}

// load balancer
variable internal {}
variable load_balancer_type {}
variable enable_deletion_protection {}
variable alb_tg_port {}
variable alb_tg_protocol {}
variable alb_tg_target_type {}
variable alb_tg_matcher {}
variable alb_tg_path {}
// http listener
variable http_listener_port {}
variable http_listener_protocol {}
variable http_listener_action_type {}
variable http_listener_redirect_port {}
variable http_listener_redirect_protocol {}
variable http_listener_redirect_status_code {}
// https listener
variable https_listener_port {}
variable https_listener_protocol {}
//variable alb_tls_cert_arn {}


// autoscaling
variable max_capacity {}
variable min_capacity {}
variable scalable_dimension {}
variable service_namespace {}
// memory policy
variable autoscaling_policy_type {}
variable predefined_metric_type_memory {}
variable memory_target_value {}
variable scale_in_cooldown {}
variable scale_out_cooldown {}
// cpu policy
variable predefined_metric_type_cpu {}
variable cpu_target_value {}


//cloudflare
variable cloudflare_email {}
variable cloudflare_api_key {}
variable domain_id {}

//atlas
variable atlas_project_id {}
variable atlas_public_key {}
variable atlas_private_key {}
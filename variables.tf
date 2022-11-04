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
//task definition
//variable task_name {}
variable net_mode {}
variable ecs_type {}
variable container_cpu {}
variable container_memory {}
//variable container_name {}
variable container_image {}
variable essential {}
variable container_port {}
variable container_host_port {}
variable protocol {}
variable log_driver {}
//variable log_group_name {}
//rol for task exc
//variable rol_name {}
//service
//variable service_name {}
variable service_desired_count {}
variable deployment_minimum_healthy_percent {}
variable deployment_maximum_percent {}
variable health_check_grace_period_seconds {}
variable scheduling_strategy {}
//variable aws_alb_target_group_arn {} --------------------------------------------
//variable private_subnets {}
//variable ecs_service_security_groups {}

// load balancer
//variable alb_name {}
variable internal {}
variable load_balancer_type {}
//variable alb_security_groups {}
//variable public_subnets {}
variable enable_deletion_protection {}
// load balancer target group
//variable alb_tg_name {}
variable alb_tg_port {}
variable alb_tg_protocol {}
variable alb_tg_target_type {}
//variable alb_tg_healthy_threshold {}
//variable alb_tg_interval {}
variable alb_tg_matcher {}
//variable alb_tg_timeout {}
variable alb_tg_path {}
//variable alb_tg_unhealthy_threshold {}
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
variable alb_tls_cert_arn {}


// autoscaling
variable max_capacity {}
variable min_capacity {}
//variable resource_id_autoscaling {}
variable scalable_dimension {}
variable service_namespace {}
// memory policy
//variable memory_pol_name {}
variable autoscaling_policy_type {}
variable predefined_metric_type_memory {}
variable memory_target_value {}
variable scale_in_cooldown {}
variable scale_out_cooldown {}
// cpu policy
//variable cpu_pol_name {}
variable predefined_metric_type_cpu {}
variable cpu_target_value {}


//cloudflare
variable cloudflare_email {}
variable cloudflare_api_key {}
variable domain_id {}

//atlas
variable atlas_project_id {}
//variable db_cluster_name {}
//variable db_user {}
//variable db_password {}
variable atlas_public_key {}
variable atlas_private_key {}